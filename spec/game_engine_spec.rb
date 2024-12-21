# frozen_string_literal: true

require_relative("../lib/game_engine")

describe OdinConnectFour::GameEngine do
  describe "#play_game" do
    subject(:game) { described_class.new }
    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:intro_game)
      allow(game).to receive(:play_round)
      allow(game).to receive(:display_game)
      allow(game).to receive(:setup_players)
      allow(game).to receive(:end_game)
    end

    it "sends call to explain game" do
      expect(game).to receive(:intro_game)
      game.play_game
    end

    it "outputs winner" do
      expect(game).to receive(:end_game)
      game.play_game
    end

    it "sends call to setup players" do
      expect(game).to receive(:setup_players)
      game.play_game
    end

    context "when third round ends game" do
      before do
        allow(game).to receive(:play_round).and_return(false, false, true)
        allow(game).to receive(:display_game)
      end

      it "calls play round 3 times" do
        expect(game).to receive(:play_round).exactly(3).times
        game.play_game
      end

      it "calls show game 3 times" do
        expect(game).to receive(:display_game).exactly(3).times
        game.play_game
      end
    end

    context "when no round ends game" do
      before do
        allow(game).to receive(:display_game)
        allow(game).to receive(:play_round).and_return(false)
      end

      it "calls play round 42 times" do
        expect(game).to receive(:play_round).exactly(42).times
        game.play_game
      end

      it "calls show game 42 times" do
        expect(game).to receive(:display_game).exactly(42).times
        game.play_game
      end
    end
  end

  describe "#play_round" do
    subject(:game_round) { described_class.new }
    let(:active_player) { instance_double("player") }
    before do
      game_round.instance_variable_set(:@active_player, active_player)
      allow(active_player).to receive(:grab_move).and_return(4)
      allow(active_player).to receive(:char).and_return("#")
      allow(game_round).to receive(:update_game)
      allow(game_round).to receive(:game_over?).and_return(true)
    end

    it "finds all rows that are full" do
      game_round.instance_variable_set(:@game_state, [%w[O O O O O O], ["O"], ["O"], ["O"], %w[O O O O O O], [], []])
      expect(active_player).to receive(:grab_move).with([0, 4])
      game_round.play_round
    end

    it "sends call to get move" do
      expect(active_player).to receive(:grab_move)
      game_round.play_round
    end

    it "adds move to game state at position 3" do
      move_loc = 3 - 1
      allow(active_player).to receive(:grab_move).and_return(3)
      expect { game_round.play_round }.to(change { game_round.instance_variable_get(:@game_state)[move_loc].length }.by(1))
    end

    it "adds move to game state at position 5" do
      move_loc = 5 - 1
      allow(active_player).to receive(:grab_move).and_return(5)
      expect { game_round.play_round }.to(change { game_round.instance_variable_get(:@game_state)[move_loc].length }.by(1))
    end

    it "move is player's character" do
      allow(active_player).to receive(:char).and_return("Q")
      game_round.play_round
      game = game_round.instance_variable_get(:@game_state)
      expect(game[3][-1]).to eq("Q")
    end

    it "move is player's character" do
      allow(active_player).to receive(:char).and_return("#")
      game_round.play_round
      game = game_round.instance_variable_get(:@game_state)
      expect(game[3][-1]).to eq("#")
    end

    it "sends call to check if game over" do
      expect(game_round).to receive(:game_over?)
      game_round.play_round
    end

    it "returns bool for if game is over" do
      result = game_round.play_round
      expect(result).to be(true)
    end

    it "swaps active player" do
      expect { game_round.play_round }.to(change { game_round.instance_variable_get(:@active_player) })
    end
  end

  describe "#game_over?" do
    subject(:game_ending) { described_class.new }
    context "when there are 4 horizontally in a row" do
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [["O"], ["O"], ["O"], ["O"], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[X X O O], %w[X X O O], %w[X X O O], %w[O O X O], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
    end
    context "when there are 4 vertically in a row" do
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[O O O O], [], [], [], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[O X O O O O], [], [], [], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
    end
    context "when there are 4 diagonally in a row" do
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[O X O O], %w[O O X X], %w[X X O O], %w[O X O O], [], [], []])
        over = game_ending.game_over?(3)
        expect(over).to be_truthy
      end
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[X X X O],
                                                         %w[X O O],
                                                         %w[O X X],
                                                         %w[X O],
                                                         %w[O X O],
                                                         %w[X O O O X O],
                                                         []])
        over = game_ending.game_over?(3)
        expect(over).to be_truthy
      end
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[O O X O O],
                                                         %w[X O O O X],
                                                         %w[O X O O O],
                                                         %w[X O X X X], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
    end
    context "when there are no 4 in a row" do
      it "returns false" do
        game_ending.instance_variable_set(:@game_state, [%w[O O X O X],
                                                         %w[X O O O X],
                                                         %w[O X O O O],
                                                         %w[X O X X X], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_falsey
      end
      it "returns false" do
        game_ending.instance_variable_set(:@game_state, [%w[O O X O X O],
                                                         %w[X O O O X X],
                                                         %w[O X O O O X],
                                                         %w[X O X X X O],
                                                         %w[X X O O X O],
                                                         %w[O X O X O X],
                                                         %w[O X O X X O]])
        over = game_ending.game_over?(2)
        expect(over).to be_falsey
      end
      it "returns false" do
        game_ending.instance_variable_set(:@game_state, [%w[],
                                                         %w[@],
                                                         %w[@ @],
                                                         %w[@],
                                                         %w[],
                                                         %w[],
                                                         %w[]])
        over = game_ending.game_over?(2)
        expect(over).to be_falsey
      end
    end
  end

  describe "#setup_players" do
    subject(:game_setup) { described_class.new }
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }

    before do
      game_setup.instance_variable_set(:@player1, player1)
      game_setup.instance_variable_set(:@player2, player2)
      allow(player1).to receive(:setup)
      allow(player2).to receive(:setup)
    end

    it "sets up player1" do
      expect(player1).to receive(:setup)
      game_setup.setup_players
    end

    it "sets up player2" do
      expect(player2).to receive(:setup)
      game_setup.setup_players
    end
  end

  describe "#end_game" do
    subject(:game_end) { described_class.new }
    let(:player1) { instance_double("player") }
    let(:player2) { instance_double("player") }
    context "when game_over is true" do
      before do
        allow(game_end).to receive(:display_game)
        game_end.instance_variable_set(:@player1, player1)
        allow(player1).to receive(:char).and_return("@")
        game_end.instance_variable_set(:@player2, player2)
        allow(player2).to receive(:char).and_return("X")
      end

      it "prints non-active player win" do
        game_end.instance_variable_set(:@active_player, player1)
        expect { game_end.end_game(true) }.to output(/X/).to_stdout
      end

      it "prints non-active player win" do
        game_end.instance_variable_set(:@active_player, player2)
        expect { game_end.end_game(true) }.to output(/@/).to_stdout
      end
    end
    context "when game_over is false" do
      before do
        allow(game_end).to receive(:display_game)
      end
      it "prints tie" do
        expect { game_end.end_game(false) }.to output(/tie/).to_stdout
      end
    end
  end
end
