# frozen_string_literal: true

require_relative("../lib/input_validation")

describe OdinConnectFour::InputValidation do
  describe "#verify_input" do
    context "when no block is given" do
      context "when input is non-empty" do
        before do
          allow(described_class).to receive(:puts)
          allow(described_class).to receive(:gets).and_return("string\n")
        end

        it "asks for input" do
          expect(described_class).to receive(:puts)
          described_class.verify_input("get input")
        end

        it "returns the input" do
          result = described_class.verify_input("get input")
          expect(result).to eq("string")
        end
      end

      context "when empty once, and then non-empty" do
        before do
          allow(described_class).to receive(:puts)
          allow(described_class).to receive(:gets).and_return("", "string")
        end

        it "prints twice" do
          expect(described_class).to receive(:puts).with("get input")
          expect(described_class).to receive(:puts).with("Invalid, try again.")
          described_class.verify_input("get input")
        end

        it "returns the input" do
          result = described_class.verify_input("get input")
          expect(result).to eq("string")
        end
      end

      context "when input is invalid n times, then valid" do
        before do
          allow(described_class).to receive(:puts)
          allow(described_class).to receive(:gets).and_return("\n", "", "", "", "", "string\n")
        end

        it "prints n+1 times" do
          expect(described_class).to receive(:puts).with("get input")
          expect(described_class).to receive(:puts).with("Invalid, try again.").exactly(5).times
          described_class.verify_input("get input")
        end

        it "returns the input" do
          result = described_class.verify_input("get input")
          expect(result).to eq("string")
        end
      end
    end
    context "when block is grabbing integer between 1 and 3" do
      let(:preprocess) { ->(str) { str.chomp.to_i } }
      let(:test) { ->(num) { (1..3).include?(num) } }
      context "when input passes block" do
        before do
          allow(described_class).to receive(:puts)
          allow(described_class).to receive(:gets).and_return("2\n")
        end

        it "asks for input" do
          expect(described_class).to receive(:puts)
          described_class.verify_input("get input message", "error message", preprocess, test)
        end

        it "returns the input" do
          result = described_class.verify_input("get input message", "error message", preprocess, test)
          expect(result).to eq(2)
        end
      end

      context "when input fails once, then is valid" do
        before do
          allow(described_class).to receive(:puts)
          allow(described_class).to receive(:gets).and_return("abc", "3")
        end

        it "prints twice" do
          expect(described_class).to receive(:puts).twice
          described_class.verify_input("get input message", "error message", preprocess, test)
        end

        it "returns the input" do
          result = described_class.verify_input("get input message", "error message", preprocess, test)
          expect(result).to eq(3)
        end
      end

      context "when input is invalid n times, then valid" do
        before do
          allow(described_class).to receive(:puts)
          allow(described_class).to receive(:gets).and_return("123", "abc", "\n", "  ", "-1", "1")
        end

        it "prints n+1 times" do
          expect(described_class).to receive(:puts).exactly(6).times
          described_class.verify_input("get input message", "error message", preprocess, test)
        end

        it "returns the input" do
          result = described_class.verify_input("get input message", "error message", preprocess, test)
          expect(result).to eq(1)
        end
      end
    end
  end
end
