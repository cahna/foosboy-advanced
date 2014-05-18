import Application from require "lapis"

class Api extends Application
  "/": =>
    "Welcome to Lapis #{require "lapis.version"}!"
