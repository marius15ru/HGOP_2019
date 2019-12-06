module.exports = (deck, dealer) => {
    dealer.shuffle(deck);
    let card0 = dealer.draw(deck);
    let card1 = dealer.draw(deck);
    let state = {
        deck: deck,
        dealer: dealer,
        cards: [
            card0,
            card1,
        ],
        // The card that the player thinks will exceed 21.
        card: undefined,
    };
    return {
        state: state,
        // Is the game over (true or false).
        // Is the game finished.
        isGameOver: (game) => {
            let total = game.getTotal(game);
            if(total < 21)
                return game.state.card ? true : false;
            return true;
        },
        // Has the player won (true or false).
        playerWon: (game) => {
            let total = game.getTotal(game);
            if(game.state.card)
                return total <= 21 ? false: true;
                
            if(total < 21 || total > 21)
                return false;
            return true;
        },
        // The highest score the cards can yield without going over 21 (integer).
        getCardsValue: (game) => {
            let sum = 0;
            let countAces = 0;
            for (let i = 0; i < game.state.cards.length; i++) {
                let number = parseInt(game.state.cards[i].substring(0,2));
                if(number == 1)
                    countAces++;
                else
                    sum += number > 10 ? 10 : number;
            }
            for (let i = 0; i < countAces; i++) {
                if((sum + 10) < 21 || game.state.card)
                    sum += 10;
                else
                    sum += 1;
            }
            return sum;
        },
        // The value of the card that should exceed 21 if it exists (integer or undefined).
        getCardValue: (game) => {
            if(game.state.card){
                let number = parseInt(game.state.card.substring(0,2));
                if(number == 1)
                    return 10;
                else if (number > 10)
                    return 10;
                else
                    return number;
            }
            return undefined;
        },
        // The cards value + the card value if it exits (integer).
        getTotal: (game) => {
            let cardValue = game.getCardValue(game);
            let cardsValue = game.getCardsValue(game);
            if(cardValue)
                return cardsValue + cardValue;
            return cardsValue;
        },
        // The player's cards (array of strings).
        getCards: (game) => {
            return game.state.cards;
        },
        // The player's card (string or undefined).
        getCard: (game) => {
            return game.state.card;
        },
        // Player action (void).
        guess21OrUnder: (game) => {
            let tempCard = game.state.dealer.draw(game.state.deck);
            game.state.cards.push(tempCard);
        },
        // Player action (void).
        guessOver21: (game) => {
            let tempCard = game.state.dealer.draw(game.state.deck);
            game.state.card = tempCard;
        },
    };
};