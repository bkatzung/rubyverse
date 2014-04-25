# Parallel Ruby universes ("Rubyverses") - A proposed interface for
# parallel, "semi-private" method or method-and-data spaces via
# "closely associated" objects.
#
# Example:
#
#    require 'rubyverse'
#    
#    class Number_Assistant
#        def initialize (original); @original = original; end
#        def my_method; "Number assistant for #{@original}"; end
#        def rubyverse_original; @original; end
#    end
#    
#    class String_Assistant
#        def initialize (original); @original = original; end
#        def my_method; "String assistant for #{@original}"; end
#        def rubyverse_original; @original; end
#    end
#    
#    class Assisted
#        include Rubyverse
#        def rubyverse_new (object)
#            case object
#            when Numeric then Number_Assistant.new(object)
#            when String then String_Assistant.new(object)
#            else self
#            end
#        end
#        def my_method; "Default assistant"; end
#    end
#    
#    object = Assisted.new
#
#    object.rubyversed(10).my_method      # "Number assistant for 10"
#    10.in_rubyverse(object).my_method    # "Number assistant for 10"
#
#    object.rubyversed("hi").my_method    # "String assistant for hi"
#    "hi".in_rubyverse(object).my_method  # "String assistant for hi"
#
#    object.rubyversed(nil).my_method     # "Default assistant"
#    nil.in_rubyverse(object).my_method   # "Default assistant"
#
# The Rubyverse module provides a reference implementation that may be
# used to extend objects that will be Rubyverses.
# The Object class is extended with supporting methods.
#
# A Rubyverse object is responsible for allocating and maintaining a
# map of appropriate parallel objects for its Rubyverse.
#
# @author Brian Katzung (briank@kappacs.com), Kappa Computer Solutions, LLC
# @license Public Domain
# @version 1.0.0
module Rubyverse

    VERSION = "1.0.0"

    # Return a parallel object in this Rubyverse corresponding to the
    # given original object.
    #
    # It is invoked by Object#in_rubyverse(rubyverse) upon the first
    # reference to each Rubyverse for each original object.
    #
    # It is recommended that parallel objects be initialized with the
    # original object and that they override #rubyverse_original to
    # return it.
    #
    # @param original The original object.
    # @abstract You MUST supply your own implementation.
    def rubyverse_new (original); end
    remove_method :rubyverse_new # API doc only

    # Return the map of original-to-#rubyversed objects.
    #
    # @param create [Boolean] Whether to create the map if it doesn't
    #  exist yet.
    # @return [Hash]
    def rubyverse_map (create = true)
	if create then @rubyverse_map ||= {}.compare_by_identity
	else @rubyverse_map
	end
    end

    # Return an object's parallel object in this Rubyverse.
    #
    # Required by {Object#in_rubyverse}.
    #
    # @param object The original object.
    def rubyversed (object)
	self.rubyverse_map[object] ||= rubyverse_new object
    end

end

# Extends the Object class to support Rubyverses.
class Object

    # Return ourselves, the original Rubyverse object.
    #
    # Parallel object classes should override this method.
    def rubyverse_original; self; end

    # Return this object's parallel object in another Rubyverse.
    #
    # This is a helper method to obtain the {Rubyverse#rubyversed}
    # object for an intermediate result in a method call chain.
    #
    #  # Three ways to invoke #something on "other" in Rubyverse "rubyverse"
    #  # and then invoke #another on the result in Rubyverse "rubyverse":
    #  rubyverse.rubyversed(other).something.in_rubyverse(rubyverse).another
    #  other.in_rubyverse(rubyverse).something.in_rubyverse(rubyverse).another
    #  rubyverse.rubyversed(rubyverse.rubyversed(other).something).another
    #
    # @param rubyverse [Rubyverse] The desired Rubyverse.
    def in_rubyverse (rubyverse); rubyverse.rubyversed self; end

end

# END
