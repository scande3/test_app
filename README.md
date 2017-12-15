# Test App

This application is to show how Rails URL generation for engines mounted at the root path is
broken in regards to subdirectories. It specifies the latest version of the Rails beta but this
issue is also present in 5.1.4.

## Installation

First install the needed gems with are default for `5.2.0.beta2` and then two test mountable engines. To
install these gem dependencies and get the application ready to run, do:

```
bundleruby install
rake db:migrate
```

To run the application, do:
```
rails s
```
## Behavior

The application has a subdirectory specified in `config/environments/development.rb` of `/v2`. In addition,
`config.ru` (the default `rails s` server) has been configured to serve from that subdirectory. I'll also
note the following behavior is also observed on Phusion Passanger running via NGINX.

`config/routes.rb` has two engines mounted: one at the route and the other at a mounted namespace. 
These engines are identical except that one uses `isolate_namespace` and the other does not as I was testing
to see if that had an effect (it did not). You can switch the routes around to verify this yourself.

Once the application is running, go to: [http://localhost:3000/v2/test](http://localhost:3000/v2/test). That
page will output what the following url helper generates for the following route:
```ruby
<%= link_to test_engine.test_path, test_engine.test_path %>
```

That route will be missing the `v2` subdirectory and thus will fail to work. Now let's try the other engine
at [http://localhost:3000/v2/mount/test2](http://localhost:3000/v2/mount/test2) and see what the following
outputs: 

```ruby
<%= link_to test_engine2.test_path, test_engine2.test_path %>
```

This will generate a correct link that include the `v2` subdirectory in it.

## Expected Result

Routing helpers should take into consideration the `config.relative_url_root` setting when generating
routes for engines mounted at the root of the application. You can play around with the mounting endpoints
for this to see that there doesn't seem to be any way to get these to work right without using a non-root 
value in the mount point.