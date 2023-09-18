module Directives
  class AnswerFromSavedMethods

    PROMPT = <<~PROMPT.freeze
    You are given a question and function output(s). Return a final answer to the question based on the function output. BE SPECIFIC, sharing data to back up your answer when you can.

    Question:: %%QUESTION%%

    # Function Output(s)
    %%FUNCTION_OUTPUTS%%

    Begin!
    PROMPT

    def initialize(question, saved_methods, eval_results)
      @question = question
      @saved_methods = saved_methods
      @eval_results = eval_results
    end

    def prompt
      replaced = PROMPT.dup
      replaced.gsub!('%%QUESTION%%', @question)
      replaced.gsub!('%%FUNCTION_OUTPUTS%%', function_outputs.to_json)
      puts "prompt=#{replaced}"
      replaced
    end

    def function_outputs
      @saved_methods.each_with_index.map do |sm, index|
        {
          question: sm.question,
          usage: sm.usage,
          output: @eval_results[index]
        }
      end
    end


  end
end