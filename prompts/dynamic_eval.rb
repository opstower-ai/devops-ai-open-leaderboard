module Directives
  module Eval
  class DynamicEval
      PROMPT = <<~PROMPT.freeze
      I'm comparing the output of two different systems. I need you to compare the two responses to the same question and see if they are functionally equivalent.

      It's ok if one response is more detailed than the other, as long as they are functionally equivalent.

      Question: %%QUESTION%%

      # Response

      %%RESPONSE_TO_EVAL%%

      # Reference Response

      %%REFERENCE_RESPONSE%%

      # Response format

      Answer in the following format:

      ```json
      {
        "confidence": Return a confidence value btw 0.0-1.0 that the responses are functionally equivalent,
        "why": "A single sentence explaining why you chose this confidence value"
      }
      ```
      Begin!
      PROMPT

      def initialize(question, response_to_eval, reference_response)
        @question = question
        @response_to_eval = response_to_eval
        @reference_response = reference_response
      end

      def prompt
        replaced = PROMPT.dup
        replaced.gsub!("%%QUESTION%%", @question)
        replaced.gsub!("%%RESPONSE_TO_EVAL%%", @response_to_eval)
        replaced.gsub!("%%REFERENCE_RESPONSE%%", @reference_response)

        replaced
      end
    end
  end
end