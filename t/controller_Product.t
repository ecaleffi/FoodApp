use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'FoodApp' }
BEGIN { use_ok 'FoodApp::Controller::Product' }

ok( request('/product')->is_success, 'Request should succeed' );
done_testing();
