# frozen_string_literal: true

require_relative("../lib/player")

describe OdinConnectFour::Player do
  describe "#grab_char" do
    subject(:player_char) { described_class.new }

    before do
      allow(player_char).to receive(:verify_input).and_return("@")
    end

    it "sends call to get verified input" do
      expect(player_char).to receive(:verify_input)
      player_char.grab_char
    end

    it "returns result" do
      expect(player_char.grab_char).to eq("@")
    end
  end

  describe "#grab_move" do
    subject(:player_move) { described_class.new }

    before do
      allow(player_move).to receive(:verify_input).and_return(3)
    end

    it "sends call to get verified input" do
      expect(player_move).to receive(:verify_input)
      player_move.grab_move([0])
    end
  end
end
