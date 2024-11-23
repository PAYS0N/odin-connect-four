# frozen_string_literal: true

require_relative("../lib/game_engine")

describe OdinConnectFour::GameEngine do
  context "when game played" do
    subject(:game_output) { described_class.new }

    before do
      allow(game_output).to receive(:puts)
    end

    it "outputs winner" do
      expect(game_output).to receive(:puts)
      game_output.play_game
    end
  end
end
