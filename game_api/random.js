module.exports = function(context) { // eslint-disable-line
    return {
        randomInt(min, max) {
            return Math.floor(Math.random() * (max - min) + min);
        },
    };
};