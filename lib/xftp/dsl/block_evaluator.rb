module XFTP
  # Contains helper classes and modules to simplify building a DSL
  module DSL
    # Gives the target class an ability to expose both DSL design patterns.
    # It yields self as a block argument if arity of the given block takes exactly 1 argument, otherwise
    # it simply evaluates the given block of the target class instance (see BasicObject#instance_eval)
    module BlockEvaluator
      def evaluate(&callback)
        return unless block_given?
        if callback.arity == 1
          yield self
        else
          instance_eval(&callback)
        end
      end
    end
  end
end
