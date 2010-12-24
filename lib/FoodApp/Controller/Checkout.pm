package FoodApp::Controller::Checkout;
use strict;
use warnings;

BEGIN {
    use base qw/Catalyst::Controller/;
    use Handel::Checkout;
    use Handel::Constants qw/:cart :order :checkout/;
    use FormValidator::Simple 0.17;
    use HTML::FillInForm;
    use YAML 0.65;
};

=head1 NAME

FoodApp::Controller::Checkout - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 COMPONENT

=cut

sub COMPONENT {
    my $self = shift->NEXT::COMPONENT(@_);

    $self->{'validator'} = FormValidator::Simple->new;
    $self->{'validator'}->set_messages(
        $_[0]->path_to('root', 'src', 'checkout', 'messages.yml')
    );

    $self->{'fif'} = HTML::FillInForm->new;

    $self->{'profiles'} = YAML::LoadFile($_[0]->path_to('root', 'src', 'checkout', 'profiles.yml'));

    return $self;
};

=head2 default 

Default action when browsing to /checkout/ that loads the checkout process for
the current shopper. If no session exists, or the shopper id isn't set, or there
os no temporary order record, nothing will be loaded. This keeps non-shoppers 
like Google and others from wasting sessions and order records for no good
reason.

=cut

sub default :Path {
    my ($self, $c) = @_;
    $c->stash->{'template'} = 'checkout/default';

    if ($c->forward('load')) {
        $c->res->redirect($c->uri_for('/checkout/billing/'));
    };

    return;
};

=head2 billing

Loads/saves the billing and shipping information during GET/POST.

    /checkout/billing/

=cut

sub billing : Local {
    my ($self, $c) = @_;
    $c->stash->{'template'} = 'checkout/billing';

    if (my $order = $c->forward('load')) {
        $c->stash->{'order'} = $order;

        if ($c->req->method eq 'POST') {
            if ($c->forward('validate')) {
                my $checkout = Handel::Checkout->new({
                    order  => $order,
                    phases => 'CHECKOUT_PHASE_VALIDATE'
                });

                if ($checkout->process == CHECKOUT_STATUS_OK) {
                    if ($checkout->order->update($c->req->params)) {
                        $c->res->redirect($c->uri_for('/checkout/preview/'));
                    };
                } else {
                    $c->stash->{'errors'} = $checkout->messages;
                };
            };
        };
    } else {
        $c->res->redirect($c->uri_for('/checkout/'));
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
        if (my $order = $c->forward($c->controller('Order'), 'load')) {
            $order->reconcile(
                $c->forward($c->controller('Cart'), 'load')
            );

            return $order;
        } elsif (my $cart = $c->forward($c->controller('Cart'), 'load')) {
            if ($cart->count) {
                if (my $order = $c->forward($c->controller('Order'), 'create', [$cart])) {
                    
                    my $checkout = Handel::Checkout->new({
                        order   => $order,
                        phases => 'CHECKOUT_PHASE_INITIALIZE'
                    });

                    if ($checkout->process != CHECKOUT_STATUS_OK) {
                        $c->stash->{'errors'} = $checkout->messages;
                    };                    
                    
                    return $checkout->order;
                };
            };
        };
    };

    return;
};

=head2 payment

Loads/Saves the payment information during GET/POST.

    /checkout/payment/

=cut

sub payment : Local {
    my ($self, $c) = @_;
    $c->stash->{'template'} = 'checkout/payment';

    if (my $order = $c->forward('load')) {
        $c->stash->{'order'} = $order;

        if ($c->req->method eq 'POST') {
            if ($c->forward('validate')) {
                my $checkout = Handel::Checkout->new({
                    order  => $order,
                    phases => 'CHECKOUT_PHASE_AUTHORIZE, CHECKOUT_PHASE_FINALIZE, CHECKOUT_PHASE_DELIVER'
                });

                if ($checkout->process == CHECKOUT_STATUS_OK) {
                	## Aggiorno le quantità delle scorte nel carrello
                	foreach my $prod ($order->items) {
                		my $product = $c->model('FoodAppDB::Product')->find( { name => $prod->sku } );
                		
                		$product->update({
                			stock_qty => $product->stock_qty - $prod->quantity,
                		});
                	}
                
                    if ($checkout->order->update) {
                        eval {
                            $c->model('Cart')->destroy({
                                shopper => $c->session->{'shopper'},
                                type    => CART_TYPE_TEMP
                            });
                        };
                        $c->stash->{'order'} = $checkout->order;
                        $c->forward('complete');
                    };
                } else {
                    $c->stash->{'errors'} = $checkout->messages;
                };
            };
        };
    } else {
        $c->res->redirect($c->uri_for('/checkout/'));
    };

    return;
};

=head2 preview

Displays a preview of the current order.

    /checkout/preview/

=cut

sub preview : Local {
    my ($self, $c) = @_;
    $c->stash->{'template'} = 'checkout/preview';

    if (my $order = $c->forward('load')) {
        $c->stash->{'order'} = $order;
    } else {
        $c->res->redirect($c->uri_for('/checkout/'));
    };

    return;
};

=head2 complete

Displays the order complete page.

=cut

sub complete : Local {
    my ($self, $c) = @_;
    $c->stash->{'template'} = 'checkout/complete';
    
    my $user = $c->user;
    $user->handel_orders->create({ order_number => $c->stash->{'order'}->id });
    
    ## Creo un ordine per l'attività di profiling
    my $order = $c->stash->{'order'};
    
    my $ord_db = $c->model('FoodAppDB::Order')->create( { number => $order->number } );
    
    # Inserisco l'associazione con i prodotti
    foreach my $item ($order->items) {
    	$ord_db->orders_items->create( { item => $item->sku } );
    }
    
    if (!$c->stash->{'order'}) {
        $c->res->redirect($c->uri_for('/checkout/'));
    };
};

=head2 render

Local render method to attach the load end method and HTML::FIllInForm to.

=cut

sub render : ActionClass('RenderView') {};

=head2 end

Runs HTML::FillInForm on the curret request before sending the output to the
browser.

=cut

sub end : Private { 
    my ($self, $c) = @_;
    $c->forward('render');

    if ($c->req->method eq 'POST') {
        $c->res->output(
            $self->{'fif'}->fill(
                scalarref => \$c->response->{body},
                fdat => $c->req->params
            )
        );
    };
};

=head2 validate

Validates the current form parameters using the profile in profiles.yml that
matches the current action.

    if ($c->forward('validate')) {
    
    };

=cut

sub validate : Private {
    my ($self, $c) = @_;

    $self->{'validator'}->results->clear;

    my $results = $self->{'validator'}->check(
        $c->req,
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
