package FoodApp::Controller::ProductRest;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::REST'; }

=head1 NAME

FoodApp::Controller::ProductRest - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched FoodApp::Controller::ProductRest in ProductRest.');
}

=head2 rest_product_list

Routine che permette di ottenere una lista di prodotti serializzata, in modo da implementare un web services a cui si possono connettere i client per ottenere informazioni sui prodotti.

=cut

sub rest_product_list :Path('/rest/product') :Args(0) :ActionClass('REST') { }


=head2 rest_product_list_GET

=cut

sub rest_product_list_GET {
	my ($self, $c) = @_;
	
	$c->req->content_type('application/json');
	
	my @products;
	my $product_rs = $c->model('FoodAppDB::Product')->search;
	my %prods_hash;
	while (my $product_row = $product_rs->next) {
		my %product_item = (name		=> $product_row->name,
							description => $product_row->description,
							price		=> $product_row->price);
		push @products, \%product_item;
	}
	$prods_hash{'prods'} = \@products;
	
	$self->status_ok( $c, entity => \%prods_hash );
}


=head1 AUTHOR

enrico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
