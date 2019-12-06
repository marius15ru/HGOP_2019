const lucky21Constructor = require('./lucky21.js');
const deckConstructor = require('./deck.js');
const dealerConstructor = require('./dealer.js');

test('a new game should have 50 cards left in the deck', () => {
    let deck = deckConstructor();
    let dealer = dealerConstructor();
    let game = lucky21Constructor(deck, dealer);
    expect(game.state.deck.length).toEqual(50);
});

test('a new game should have 2 drawn cards', () => {
    let deck = deckConstructor();
    let dealer = dealerConstructor();
    let game = lucky21Constructor(deck, dealer);
    expect(game.state.cards.length).toEqual(2);
});


test('guess21OrUnder should draw the next card', () => {
  // Arrange
    let deck = deckConstructor();
    deck = [
        '05C', '01D', '09S', '10H', 
    ];
    let dealer = dealerConstructor();
    // Override the shuffle to do nothing.
    dealer.shuffle = () => {};
    
    // Inject our dependencies
    let game = lucky21Constructor(deck, dealer);
    
    // Act
    game.guess21OrUnder(game);
    
    // Assert
    expect(game.state.cards.length).toEqual(3);
    expect(game.state.cards[2]).toEqual('01D');
});

test('playerWon should return true', () => {
    let deck = deckConstructor();
    deck = [
        '07C', '07D', '07S', 
    ];
    let dealer = dealerConstructor();
    dealer.shuffle = () => {};
    
    let game = lucky21Constructor(deck, dealer);

    game.guess21OrUnder(game);

    expect(game.playerWon(game)).toEqual(true);
});

test('isGameOver should return false', () => {
    let deck = deckConstructor();
    deck = [
        '02C', '04D', '06S', '08H' 
    ];
    let dealer = dealerConstructor();
    dealer.shuffle = () => {};
    
    let game = lucky21Constructor(deck, dealer);

    game.guess21OrUnder(game);

    expect(game.isGameOver(game)).toEqual(false);
});

test('isGameOver should return false', () => {
    let deck = deckConstructor();
    deck = [
        '02C', '04D', '06S', '08H' 
    ];
    let dealer = dealerConstructor();
    dealer.shuffle = () => {};
    
    let game = lucky21Constructor(deck, dealer);

    game.guessOver21(game);

    expect(game.isGameOver(game)).toEqual(true);
});

test('getCardsValue should be equal to 20', () => {
    let deck = deckConstructor();
    deck = [
        '01C', '05D', '04S', '01H', 
    ];
    let dealer = dealerConstructor();
    dealer.shuffle = () => {};
    
    let game = lucky21Constructor(deck, dealer);

    game.guess21OrUnder(game);
    game.guess21OrUnder(game);

    expect(game.getCardsValue(game)).toEqual(20);
});

test('getCardsValue should be equal to 24', () => {
    let deck = deckConstructor();
    deck = [
        '02C', '01D', '02S', '01H', 
    ];
    let dealer = dealerConstructor();
    dealer.shuffle = () => {};
    
    let game = lucky21Constructor(deck, dealer);

    game.guess21OrUnder(game);
    game.guessOver21(game);

    expect(game.getTotal(game)).toEqual(24);
    expect(game.isGameOver(game)).toEqual(true);
});

test('getCardValue should be equal to 5', () => {
    let deck = deckConstructor();
    deck = [
        '01C', '05D', '04S', '01H', 
    ];
    let dealer = dealerConstructor();
    dealer.shuffle = () => {};
    
    let game = lucky21Constructor(deck, dealer);

    game.guessOver21(game);

    expect(game.getCardValue(game)).toEqual(5);
});

test('getTotal should be equal to 19', () => {
    let deck = deckConstructor();
    deck = [
        '01C', '05D', '04S', '01H', 
    ];
    let dealer = dealerConstructor();
    dealer.shuffle = () => {};
    
    let game = lucky21Constructor(deck, dealer);

    game.guessOver21(game);

    expect(game.getTotal(game)).toEqual(19);
});

test("getCards should return the array ['01H', '04S', '05D']", () => {
    let deck = deckConstructor();
    deck = [
        '01C', '05D', '04S', '01H', 
    ];
    let dealer = dealerConstructor();
    dealer.shuffle = () => {};
    
    let game = lucky21Constructor(deck, dealer);

    game.guess21OrUnder(game);

    expect(game.getCards(game)).toEqual(['01H', '04S', '05D']);
});

test('getCard should be equal to 20', () => {
    let deck = deckConstructor();
    deck = [
        '01C', '05D', '04S', '01H', 
    ];
    let dealer = dealerConstructor();
    dealer.shuffle = () => {};
    
    let game = lucky21Constructor(deck, dealer);

    game.guessOver21(game);

    expect(game.getCard(game)).toEqual('05D');
});

test('guessOver21 should assign "01D" to game.state.card', () => {
    // Arrange
      let deck = deckConstructor();
      deck = [
          '05C', '01D', '09S', '10H', 
      ];
      let dealer = dealerConstructor();
      // Override the shuffle to do nothing.
      dealer.shuffle = () => {};
      
      // Inject our dependencies
      let game = lucky21Constructor(deck, dealer);
      
      // Act
      game.guessOver21(game);
      
      // Assert
      expect(game.state.card).toEqual('01D');
  });