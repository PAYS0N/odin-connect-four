# frozen_string_literal: true

require_relative("../lib/game_engine")

describe OdinConnectFour::GameEngine do
  subject(:game) { described_class.new }

  context "#play_game" do
    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:intro_game)
      allow(game).to receive(:play_round)
    end

    it "explains game" do
      expect(game).to receive(:intro_game)
      game.play_game
    end

    it "outputs winner" do
      expect(game).to receive(:puts)
      game.play_game
    end

    context "when third round ends game" do
      before do
        allow(game).to receive(:play_round).and_return(false, false, true)
      end

      it "stops when game is over" do
        expect(game).to receive(:play_round).exactly(3).times
        game.play_game
      end
    end

    context "when no round ends game" do
      before do
        allow(game).to receive(:play_round).and_return(false)
      end

      it "stops after the 42nd round" do
        expect(game).to receive(:play_round).exactly(42).times
        game.play_game
      end
    end
  end
end
