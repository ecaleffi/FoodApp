package FoodApp;
use Moose;
use namespace::autoclean;
use Locale::Currency::Format;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    
    Authentication
    Authorization::Roles
    Session
    Session::State::Cookie
    Session::Store::FastMmap
    
    FormValidator::Simple
    FillInForm
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in foodapp.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'FoodApp',
    'View::TT' => {
    	INCLUDE_PATH => [
    		__PACKAGE__->path_to('root', 'src'),
    		__PACKAGE__->path_to('root', 'lib')
    	],
    	TEMPLATE_EXTENSION 	=> '.tt',
    	CATALYST_VAR		=> 'c',
    	TIMER				=> 0,
    	WRAPPER				=> 'site/wrapper'
    },
    'Plugin::Authentication' => {
    	default => {
    		credential => {
    			class => 'Password',
    			password_field => 'password',
    			password_type => 'clear'
    		},
    		store => {
    			class => 'DBIx::Class',
    			user_model => 'FoodAppDB::User',
    			role_relation => 'roles',
    			role_field => 'description',
    			use_userdata_from_session => '1'
    		}
    	}
    },
    'Locale::Currency::Format' => {
    	currency_set('EUR', '#.###,## EUR', FMT_STANDARD),
    }
);

# Start the application
__PACKAGE__->setup();


=head1 NAME

FoodApp - Catalyst based application

=head1 SYNOPSIS

    script/foodapp_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<FoodApp::Controller::Root>, L<Catalyst>

=head1 AUTHOR

enrico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
