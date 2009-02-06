// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var overlayTimeout;

Ajax.Responders.register({
  onCreate: function() {
    if($('overlay') && Ajax.activeRequestCount > 0)
      overlayTimeout = Effect.Appear.delay(0.5, 'overlay', {duration:0.2, queue:'end'});
  },
  onComplete: function() {
    if($('overlay') && Ajax.activeRequestCount == 0) {
      window.clearTimeout(overlayTimeout);
      Effect.Fade('overlay', {duration:0.2, queue:'end'});
    }
  }
});
