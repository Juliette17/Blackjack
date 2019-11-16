function Model()
{
    var obj = {
        deck: new Array(52),
        playerSum : 0,
        dealerSum : 0,
    }

    for (var i = 0; i < obj.deck.length; ++i)
            obj.deck[i] = i;

    obj.getCard = function(index) {
        return this.deck[index]
    }

    obj.getCardPicture = function(index) {
        return "cards/" + this.getCard(index) + ".png"
    }

    obj.shuffle = function() {
        for (var i = 0; i < this.deck.length; ++i) {
           var j = Math.floor(Math.random() * (this.deck.length))
           var temp = this.deck[i]
           this.deck[i] = this.deck[j]
           this.deck[j] = temp
         }
    }

    obj.takeOne = function(isPlayer, currentCard) {
        var points
        var cardValue = this.deck[currentCard] % 13
        if ((cardValue) >= 1 && cardValue <= 9)
            points = cardValue + 1
        else if ((cardValue == 0) && isPlayer === true) {
            if (this.playerSum <= 10)
                points = 11
            else
                points = 1
        }

        else if ((cardValue == 0) && isPlayer === false) {
            if (this.dealerSum <= 10)
                points = 11
            else
                points = 1
        }
        else
            points = 10

        console.log("card value " + cardValue + " points " + points)

        if (isPlayer === true)
            this.playerSum += points
        else
            this.dealerSum += points

        window.sum = this.playerSum
        window.dealerSum = this.dealerSum
    }

    obj.dealerPlays = function() {
        var currentCard = 12
        while (this.dealerSum < 17) {
            this.takeOne(false, currentCard)
            currentCard += 1
        }
        return (currentCard - 12)
    }

    obj.gameOver = function() {
        if (this.playerSum > 21)
            return 2 //dealer wins
        if (this.playerSum === 21)
            return 1
        if (this.dealerSum > 21)
            return 1
        if (this.dealerSum === 21)
            return 2
        if (this.dealerSum < this.playerSum)
            return 1
    }
    return obj
}
