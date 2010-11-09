use Test::More tests => 3;
use strict;
use warnings;

use_ok('Catalyst::Test', 'FoodApp');
use_ok('FoodApp::Controller::Order');

ok(request('/order')->is_success, 'Request should succeed');
