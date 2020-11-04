"use strict";
var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var __assign = (this && this.__assign) || Object.assign || function(t) {
    for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
    }
    return t;
};
var __rest = (this && this.__rest) || function (s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
        t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
        for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) if (e.indexOf(p[i]) < 0)
            t[p[i]] = s[p[i]];
    return t;
};
exports.__esModule = true;
var React = require("react");
var react_native_1 = require("react-native");
var PropTypes = require("prop-types");
var ViewPropTypes = require('react-native').ViewPropTypes;
var MessageHandler_1 = require("./MessageHandler");
var UnityModule_1 = require("./UnityModule");
var UIManager = react_native_1.NativeModules.UIManager;
var UnityView = /** @class */ (function (_super) {
    __extends(UnityView, _super);
    function UnityView(props) {
        return _super.call(this, props) || this;
    }
    UnityView.prototype.UNSAFE_componentWillMount = function () {
        var _this = this;
        this.handle = UnityModule_1.UnityModule.addMessageListener(function (message) {
            if (_this.props.onUnityMessage && message instanceof MessageHandler_1["default"]) {
                _this.props.onUnityMessage(message);
            }
            if (_this.props.onMessage && typeof message === 'string') {
                _this.props.onMessage(message);
            }
        });
    };
    UnityView.prototype.componentWillUnmount = function () {
        UnityModule_1.UnityModule.removeMessageListener(this.handle);
    };
    /**
     * [Deprecated] Use `UnityModule.pause` instead.
     */
    UnityView.prototype.pause = function () {
        UnityModule_1.UnityModule.pause();
    };
    ;
    /**
     * [Deprecated] Use `UnityModule.resume` instead.
     */
    UnityView.prototype.resume = function () {
        UnityModule_1.UnityModule.resume();
    };
    ;
    /**
     * [Deprecated] Use `UnityModule.postMessage` instead.
     */
    UnityView.prototype.postMessage = function (gameObject, methodName, message) {
        UnityModule_1.UnityModule.postMessage(gameObject, methodName, message);
    };
    ;
    /**
     * [Deprecated] Use `UnityModule.postMessageToUnityManager` instead.
     */
    UnityView.prototype.postMessageToUnityManager = function (message) {
        UnityModule_1.UnityModule.postMessageToUnityManager(message);
    };
    ;
    UnityView.prototype.render = function () {
        var _a = this.props, onUnityMessage = _a.onUnityMessage, onMessage = _a.onMessage, props = __rest(_a, ["onUnityMessage", "onMessage"]);
        return (React.createElement(react_native_1.View, __assign({}, props),
            React.createElement(NativeUnityView, { style: { position: 'absolute', left: 0, right: 0, top: 0, bottom: 0 }, onUnityMessage: onUnityMessage, onMessage: onMessage }),
            this.props.children));
    };
    UnityView.propTypes = __assign({}, ViewPropTypes, { onMessage: PropTypes.func });
    return UnityView;
}(React.Component));
exports["default"] = UnityView;
var NativeUnityView = react_native_1.requireNativeComponent('UnityView', UnityView);
//# sourceMappingURL=UnityView.js.map