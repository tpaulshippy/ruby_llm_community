# frozen_string_literal: true

RSpec.describe RubyLLM::Providers::Bedrock do
  describe '#build_guardrail_headers' do
    let(:provider) { described_class.new }

    before do
      RubyLLM.configure do |config|
        config.bedrock_api_key = 'test-key'
        config.bedrock_secret_key = 'test-secret'
        config.bedrock_region = 'us-west-2'
      end
    end

    after do
      RubyLLM.configure do |config|
        config.bedrock_guardrail_identifier = nil
        config.bedrock_guardrail_version = nil
      end
    end

    context 'when guardrail identifier is configured' do
      before do
        RubyLLM.configure do |config|
          config.bedrock_guardrail_identifier = 'abc123'
          config.bedrock_guardrail_version = '3'
        end
      end

      it 'returns headers with guardrail identifier and version' do
        headers = provider.build_guardrail_headers
        expect(headers).to eq(
          'X-Amzn-Bedrock-GuardrailIdentifier' => 'abc123',
          'X-Amzn-Bedrock-GuardrailVersion' => '3'
        )
      end
    end

    context 'when guardrail identifier is configured without version' do
      before do
        RubyLLM.configure do |config|
          config.bedrock_guardrail_identifier = 'abc123'
          config.bedrock_guardrail_version = nil
        end
      end

      it 'defaults version to DRAFT' do
        headers = provider.build_guardrail_headers
        expect(headers).to eq(
          'X-Amzn-Bedrock-GuardrailIdentifier' => 'abc123',
          'X-Amzn-Bedrock-GuardrailVersion' => 'DRAFT'
        )
      end
    end

    context 'when guardrail identifier is not configured' do
      before do
        RubyLLM.configure do |config|
          config.bedrock_guardrail_identifier = nil
          config.bedrock_guardrail_version = nil
        end
      end

      it 'returns empty headers' do
        headers = provider.build_guardrail_headers
        expect(headers).to eq({})
      end
    end

    context 'when guardrail identifier is an empty string' do
      before do
        RubyLLM.configure do |config|
          config.bedrock_guardrail_identifier = ''
          config.bedrock_guardrail_version = '2'
        end
      end

      it 'returns empty headers' do
        headers = provider.build_guardrail_headers
        expect(headers).to eq({})
      end
    end
  end
end
