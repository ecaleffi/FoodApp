package FoodApp::Controller::OrderRest;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::REST'; }

=head1 NAME

FoodApp::Controller::OrderRest - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched FoodApp::Controller::OrderRest in OrderRest.');
}

=head2 rest_order_list

Routine che permette di ottenere una lista di ordini serializzata, in modo da implementare un web services a cui si possono connettere i client per ottenere informazioni sugli ordini per effettuare analisi statistiche sulla confidenza.

=cut

sub rest_order_list :Path('/rest/order') :Args(0) :ActionClass('REST') { }


=head2 rest_order_list_GET

=cut

sub rest_order_list_GET {
	my ($self, $c) = @_;
	
	$c->req->content_type('application/json');
	
	my @orders = ();
	my %orders_hash = ();
	my $orders_rs = $c->model('FoodAppDB::Order')->search;
	while (my $order_row = $orders_rs->next) {
		my @prods = ();
		foreach my $prod ($order_row->orders_items) {
			push @prods, $prod->item;
		}
		## Inserisco lo id dell'ordine in un hash temporaneo
		my %order_item = (	id => $order_row->id,
							number => $order_row->number);
		## Inserisco l'array dei prodotti associati all'ordine nell'hash con chiave products
		push @{ $order_item{products} }, @prods;
		## Inserisco l'hash temporaneo nell'array di ordini
		push @orders, \%order_item;
	}
	$orders_hash{'orders'} = \@orders;
	
	$self->status_ok( $c, entity => \%orders_hash );
}

=head1 AUTHOR

enrico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
