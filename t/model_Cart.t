use Test::More tests => 2;
use strict;
use warnings;

BEGIN {
    use_ok('Catalyst::Test', 'FoodApp');
    use_ok('FoodApp::Model::Cart');
};
