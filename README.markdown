# Gluestick

Gluestick is a simple interface to the Glue API for Ruby.
Rather than learning a new set of methods, you just use Glue's native methods.

## Get your construction paper out: A Tutorial

To get started, include the **gluestick** gem and instantiate a Glue class.
Every method in the Glue API requires authentication, so you'll also need to use a valid username and password.

    require 'rubygems'
    require 'gluestick'
    glue = Glue.new
    response = glue.user.login({:userId => 'userid', :password => 'password'})

To actually use methods, call the same ones you would as if you were calling them right through HTTP.
If you wanted to use the `user/friends` method, you would do this:

    friends = glue.user.friends(:userId => 'jdp')

See the correspondence? `glue.user.friends` maps itself to `http://api.getglue.com/v2/user/friends`.

Query string parameters are passed through a hash as the first argument. **That's all you need to know.**

## About

2009 [Justin Poliey](http://justinpoliey.com)

2010 [HeresTomWithTheWeather](http://www.opensourcecurrency.org) - updated gem for V2

## PHP Version

Gluestick is also available as a PHP library.
It is available in the 'php' branch, or you can just follow [this link](http://github.com/jdp/gluestick/tree/php).
