var React = require('react-native');

var {
	PropTypes,
	requireNativeComponent
} = React;

var _TokBoxVideo = React.createClass({
	propTypes: {
		onLoad: PropTypes.func
	},
	_onLoad(event) {
		this.props.onLoad && this.props.onLoad(event.nativeEvent);
	},
	render: function() {
		return <TokBoxVideo {...this.props} />;
	}
});

var TokBoxVideo = requireNativeComponent('TokBoxVideo', _TokBoxVideo);
module.exports = TokBoxVideo;