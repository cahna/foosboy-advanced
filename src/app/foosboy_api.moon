
import Application from require "lapis"
import respond_to, assert_error, capture_errors_json from require "lapis.application"
import encode from require "cjson"

class FoosboyApi extends Application
  @include "app.players", path: "/api/players"
  @include "app.teams",   path: "/api/teams"

  handle_404: =>
    status: 404, json: {
      errors: {{"Unknown route", "#{@req.cmd_url}"}}
    }

  default_route: capture_errors_json =>
    if @req.parsed_url.path\match "./$"
      stripped = @req.parsed_url.path\match "^(.+)/+$"
      redirect_to: @build_url(stripped, query: @req.parsed_url.query), status: 301
    else
      ngx.log ngx.NOTICE, "User hit unknown path #{@req.parsed_url.path}"
      @app.handle_404 @

  [index: "/"]: =>
    "Welcome to Foosboy-Advanced on Lapis #{require "lapis.version"} in Docker"
