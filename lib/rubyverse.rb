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
#        def rubyverse_new (object)
#            case object
#            when Numeric then Number_Assistant.new(object)
#            when String then String_Assistant.new(object)
#            else self
#            end
#        end
#    
#        def my_method; "Default assistant"; end
#    end
#    
#    object = Assisted.new # An object implementing #rubyverse_new
#    10.in_rubyverse(object).my_method    # "Number assistant for 10"
#    "hi".in_rubyverse(object).my_method  # "String assistant for hi"
#    nil.in_rubyverse(object).my_method   # "Default assistant"
#
# The Rubyverse module is only for documentation purposes.
# The Object class is extended with supporting methods.
#
# A Rubyverse object is responsible for allocating appropriate parallel
# objects for its Rubyverse.
#
# @author Brian Katzung (briank@kappacs.com), Kappa Computer Solutions, LLC
# @license Public Domain
# @version 0.0.1
module Rubyverse

    VERSION = "0.0.1"

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
    def rubyverse_new (original); original; end

end

# Extends the Object class to support Rubyverses.
class Object

    # Return the map of Rubyverses to parallel objects.
    #
    # @param create [Boolean] Whether to create the map if it doesn't exist.
    # @return [Hash]
    def rubyverse_map (create = true)
	if create then @rubyverse_map ||= {}
	else @rubyverse_map
	end
    end

    # Return ourselves, the original Rubyverse object.
    #
    # Parallel object classes should override this method.
    def rubyverse_original; self; end

    # Return this object's parallel object in another Rubyverse.
    #
    # @param rubyverse [Rubyverse] The desired Rubyverse.
    def in_rubyverse (rubyverse)
	rubyverse_map[rubyverse] ||= rubyverse.rubyverse_new self
    end

end

# END
