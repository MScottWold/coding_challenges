/*
 * ATTENTION: The "eval" devtool has been used (maybe by default in mode: "development").
 * This devtool is not neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ "./src/board.js":
/*!**********************!*\
  !*** ./src/board.js ***!
  \**********************/
/*! unknown exports (runtime-defined) */
/*! runtime requirements: module, __webpack_require__ */
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

eval("const Snake = __webpack_require__(/*! ./snake */ \"./src/snake.js\");\n\nclass Board {\n  constructor() {\n    this.snake = new Snake;\n    this.currentDir = 'N';\n    this.generateApple();\n    this.canTurn = true;\n    this.score = 0;\n  }\n\n  generateApple() {\n    this.apple = [\n      Math.floor(Math.random() * 20),\n      Math.floor(Math.random() * 20)\n    ];\n  }\n\n  move() {\n    const deltaPos = Board.DIRECTIONS[this.currentDir];\n    const nextPos = this.snake.nextHeadPos(deltaPos);\n\n    if (nextPos[0] === this.apple[0] && nextPos[1] === this.apple[1]) {\n      this.snake.addSegment(nextPos, deltaPos);\n      this.score += 1;\n      this.generateApple();\n    } else {\n      this.snake.move(deltaPos);\n    }\n    this.snake.canTurn = true;\n  }\n\n  turn(dir) {\n    if (!this.isOpposite(dir) && this.canTurn) {\n      this.currentDir = dir;\n      this.canTurn = false;\n    }\n  }\n\n  isOpposite(dir) {\n    if ((this.currentDir === 'N' && dir === 'S') ||\n      (this.currentDir === 'S' && dir === 'N') ||\n      (this.currentDir === 'E' && dir === 'W') ||\n      (this.currentDir === 'W' && dir === 'E')) {\n      return true;\n    }\n    return false;\n  }\n\n  isOver() {\n    if (this.outOfBounds() || this.snake.ateSelf()) {\n      return true;\n    }\n\n    return false;\n  }\n\n  outOfBounds() {\n    const headCoord = this.snake.head().coord;\n\n    return headCoord[0] < 0 ||\n      headCoord[0] > 19 ||\n      headCoord[1] < 0 ||\n      headCoord[1] > 19;\n  }\n}\n\nBoard.DIRECTIONS = {\n  'N': [-1, 0],\n  'S': [1, 0],\n  'E': [0, 1],\n  'W': [0, -1]\n}\n\nmodule.exports = Board;\n\n//# sourceURL=webpack:///./src/board.js?");

/***/ }),

/***/ "./src/game_view.js":
/*!**************************!*\
  !*** ./src/game_view.js ***!
  \**************************/
/*! unknown exports (runtime-defined) */
/*! runtime requirements: module */
/*! CommonJS bailout: module.exports is used directly at 68:0-14 */
/***/ ((module) => {

eval("class GameView {\n  constructor(board, $el) {\n    this.board = board;\n    this.$el = $el;\n\n    this.setupBoard();\n    this.render();\n    // this.$el.closest('html').on('keydown',this.handleKeyPress.bind(this));\n    $(window).on('keydown', this.handleKeyPress.bind(this));\n\n    this.interval = setInterval(() => {\n      this.board.move();\n      if (this.board.isOver()) {\n        clearInterval(this.interval);\n        // this.$el.closest('html').off('keydown');\n        $(window).off('keydown');\n        alert(`game over - score: ${this.board.score}`);\n      } else {\n        this.render();\n        this.board.canTurn = true;\n      }\n    }, 100);\n  }\n\n  setupBoard() {\n    for (let i = 0; i < 20; i++) {\n      const $row = $('<div class=\"row\"></div>');\n      for (let j = 0; j < 20; j++) {\n        const $square = $('<div></div>');\n        $row.append($square);\n      }\n      this.$el.append($row);\n    }\n  }\n\n  render() {\n    $('.row > div').removeClass();\n    const $rows = this.$el.find('.row');\n\n    this.board.snake.tail.forEach((segment) => {\n      const pos = segment.coord;\n      const $square = $rows.eq(pos[1]).children().eq(pos[0]);\n\n      $square.addClass('snake');\n    });\n\n    const $appleSquare = $rows.eq(this.board.apple[1]).children().eq(this.board.apple[0]);\n    $appleSquare.addClass('apple');\n    $('.score').text(`Score: ${this.board.score}`)\n  }\n\n  handleKeyPress(event) {\n    const key = event.keyCode\n    if (key === 37) {\n      this.board.turn('W');\n    } else if (key === 38) {\n      this.board.turn('N');\n    } else if (key === 39) {\n      this.board.turn('E');\n    } else if (key === 40) {\n      this.board.turn('S');\n    } else if (key === 32) {\n      clearInterval(this.interval);\n    }\n  }\n}\n\nmodule.exports = GameView;\n\n//# sourceURL=webpack:///./src/game_view.js?");

/***/ }),

/***/ "./src/segment.js":
/*!************************!*\
  !*** ./src/segment.js ***!
  \************************/
/*! unknown exports (runtime-defined) */
/*! runtime requirements: module */
/***/ ((module) => {

eval("class Segment {\n  constructor(coord) {\n    this.coord = coord;\n    this.nextCoords = []\n  }\n\n  addCoord(coord) {\n    this.nextCoords.push(coord);\n  }\n\n  move(coord) {\n    this.addCoord(coord); \n    this.coord = this.nextCoord(this.nextCoords.shift());\n  }\n\n  nextCoord(deltaPos) {\n    return [this.coord[0] + deltaPos[0], this.coord[1] + deltaPos[1]];\n  }\n\n  equals(coord) {\n    return this.coord[0] === coord[0] && this.coord[1] === coord[1];\n  }\n}\n\nmodule.exports = Segment;\n\n//# sourceURL=webpack:///./src/segment.js?");

/***/ }),

/***/ "./src/snake.js":
/*!**********************!*\
  !*** ./src/snake.js ***!
  \**********************/
/*! unknown exports (runtime-defined) */
/*! runtime requirements: module, __webpack_require__ */
/***/ ((module, __unused_webpack_exports, __webpack_require__) => {

eval("const Segment = __webpack_require__(/*! ./segment.js */ \"./src/segment.js\");\n\nclass Snake {\n  constructor() {\n    this.tail = [new Segment([10, 10])];\n  }\n\n  move(deltaPos) {\n    this.tail.forEach((segment) => {\n      segment.move(deltaPos);\n    });\n  }\n\n  addSegment(newSegementCoord, movementCoord) {\n    this.tail.forEach((segment) => {\n      segment.addCoord(movementCoord);\n    });\n\n    this.tail.unshift(new Segment(newSegementCoord));\n  }\n\n  nextHeadPos(deltaPos) {\n    return this.head().nextCoord(deltaPos);\n  }\n\n  head() {\n    return this.tail[0];\n  }\n\n  ateSelf() {\n    const headPos = this.head().coord;\n    for (let i = 1; i < this.tail.length; i++) {\n      if (this.tail[i].equals(headPos)) {\n        return true;\n      }\n    }\n    return false;\n  }\n}\n\nmodule.exports = Snake;\n\n//# sourceURL=webpack:///./src/snake.js?");

/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		if(__webpack_module_cache__[moduleId]) {
/******/ 			return __webpack_module_cache__[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
(() => {
/*!**********************!*\
  !*** ./src/index.js ***!
  \**********************/
/*! unknown exports (runtime-defined) */
/*! runtime requirements: __webpack_require__ */
eval("const GameView = __webpack_require__(/*! ./game_view.js */ \"./src/game_view.js\");\nconst Board = __webpack_require__(/*! ./board.js */ \"./src/board.js\");\n\n$(() =>{\n  const gameView = new GameView(new Board, $('.game'));\n})\n\n//# sourceURL=webpack:///./src/index.js?");
})();

/******/ })()
;