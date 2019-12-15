import axios from "axios";
// TODO: Add correct api Url

const instance = axios.create({
  baseURL: "http://localhost:3000"
});

export const startGame = () => {
  return instance.post( '/start' ).then(res => {
    return getState();
  });
};

export const getState = () => {
  return instance.get( '/state' );
};

export const guessOver21 = () => {
  return instance.post( '/guessOver21' );
};

export const guess21OrUnder = () => {
  return instance.post( '/guess21OrUnder' );
};

// Helper function to convert cards format
export const convertCardNamesForSvg = cards => {
  return cards.map(card => {
    card = card.toLowerCase();
    if (card[0] === "1") {
      switch (card[1]) {
        case "1":
          return `J${card[2]}`;
        case "2":
          return `Q${card[2]}`;
        case "3":
          return `K${card[2]}`;
        default:
          return card;
      }
    } else {
      if (card[1] === "1") {
        return `A${card[2]}`;
      } else {
        return card.slice(1);
      }
    }
  });
};
