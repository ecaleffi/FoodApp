package FoodApp::Controller::Order;
use strict;
use warnings;

BEGIN {
    use base qw/Catalyst::Controller/;
    use Handel::Constants qw/:order/;
    use FormValidator::Simple 0.17;
    use YAML 0.65;
};

=head1 NAME

FoodApp::Controller::Order - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 COMPONENT

=cut

sub COMPONENT {
    my $self = shift->NEXT::COMPONENT(@_);

    $self->{'validator'} = FormValidator::Simple->new;
    $self->{'validator'}->set_messages(
        $_[0]->path_to('root', 'src', 'order', 'messages.yml')
    );

    $self->{'profiles'} = YAML::LoadFile($_[0]->path_to('root', 'src', 'order', 'profiles.yml'));

    return $self;
};

=head2 default

Default action when browsing to /order/ that lists the saved orders for the
current shopper. If no session exists, or the shopper id isn't set, no orders
will be loaded. This keeps non-shoppers like Google and others from wasting
sessions and order records for no good reason.

=cut

sub default : Private {
    my ($self, $c) = @_;
    $c->stash->{'template'} = 'order/default';

    if ($c->sessionid && $c->session->{'shopper'}) {
        my $orders = $c->model('Order')->search({
            shopper => $c->session->{'shopper'},
            type    => ORDER_TYPE_SAVED
        });

        $c->stash->{'orders'} = $orders;
    };

    return;
};

=head2 create

Creates a new order from the current shopping cart.

    my $order = $c->forward('create');

=cut

sub create : Private {
    my ($self, $c, $cart) = @_;

    if ($c->sessionid && $c->session->{'shopper'}) {
        return $c->model('Order')->create({
            shopper => $c->session->{'shopper'},
            type    => ORDER_TYPE_TEMP,
            cart    => $cart
        });
    };

    return;
};

=head2 load

Loads the current temporary order for the current shopper.

    my $order = $c->forward('load');

=cut

sub load : Private {
    my ($self, $c) = @_;

    if ($c->sessionid && $c->session->{'shopper'}) {
        return $c->model('Order')->search({
            shopper => $c->session->{'shopper'},
            type    => ORDER_TYPE_TEMP
        })->first;
    };

    return;
};

=head2 view

=over

=item Parameters: id

=back

Loads the specified order and displays its details during a GET operation.

    /order/view/$id

=cut

sub view :Local {
    my ($self, $c, $id) = @_;
    $c->stash->{'template'} = 'order/view';

	if ($id) {
    #if ($id && $c->sessionid && $c->session->{'shopper'}) {
        if ($c->forward('validate', [{id => $id}])) {
            my $order = $c->model('Order')->search({
                #shopper => $c->session->{'shopper'},
                id   => $id,
                type    => ORDER_TYPE_SAVED
            })->first;

            if ($order) {
                $c->stash->{'order'} = $order;
                $c->stash->{'items'} = $order->items;
            };
        };
    };

    return;
};

=head2 validate

Validates the current form parameters using the profile in profiles.yml that
matches the current action.

    if ($c->forward('validate')) {
    
    };

=cut

sub validate : Private {
    my ($self, $c, $query) = @_;

    $query ||= $c->req;

    $self->{'validator'}->results->clear;

    my $results = $self->{'validator'}->check(
        $query,
        $self->{'profiles'}->{$c->action}
    );

    if ($results->success) {
        return $results;
    } else {
        $c->stash->{'errors'} = $results->messages($c->action);
    };

    return;
};

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
