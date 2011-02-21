package FoodApp::Controller::MachineRest;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::REST'; }

=head1 NAME

FoodApp::Controller::MachineRest - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched FoodApp::Controller::MachineRest in MachineRest.');
}

=head2 rest_machine_list

Routine che permette di ottenere una lista serializzata di distributori, prodotti
appartenenti ai distributori e relazioni fra di essi.
In questo modo è possibile passare ad Android queste informazioni.

=cut

sub rest_machine_list :Path('/rest/machine') :Args(0) :ActionClass('REST') { }

=head2 rest_machine_list_GET

=cut

sub rest_machine_list_GET {
	my ($self, $c) = @_;
	
	$c->req->content_type('application/json');
	
	my @machines = ();			#Array per salvare la lista di distributori
	my %machines_hash = ();		#Hash per salvare la lista dei distributori con le loro informazioni
	
	my $machines_rs = $c->model('FoodAppDB::Machine')->search;
	while (my $machine_row = $machines_rs->next) {
	
		my @prods = (); # Array che conterrà i prodotti del distributore corrente
		
		foreach my $prod ($machine_row->products_contained) {
			push @prods, $prod->product->id; #Inserisco nell'array gli id dei prodotti che contiene
		}
		
		# Inserisco le informazioni del distributore in un hash temporaneo
		my %machine_item = ( 	id 				=> 	$machine_row->id,
								name 			=> 	$machine_row->name,
								address			=>	$machine_row->address,
								city			=>	$machine_row->city,
								province_state 	=>	$machine_row->province_state,
								postal_code		=>	$machine_row->postal_code,
								latitude		=>	$machine_row->latitude,
								longitude		=>	$machine_row->longitude);
								
		# Inserisco nell'hash gli id dei prodotti che contiene
		push @{ $machine_item {products} }, @prods;
		
		# Inserisco l'hash temporaneo nell'array di distributori
		push @machines, \%machine_item;
	}
	
	my @products = (); # Array per salvare la lista dei prodotti delle macchine
	
	my $products_rs = $c->model('FoodAppDB::MachineProduct')->search;
	while (my $product_row = $products_rs->next) {
		my %product_item = (	id			=> $product_row->id,
								name		=> $product_row->name,
								description	=> $product_row->description,
								price		=> $product_row->price,
								qty			=> $product_row->qty );
		push @products, \%product_item;
	}
	
	$machines_hash{'machines'} = \@machines;
	$machines_hash{'products'} = \@products;
	
	$self->status_ok( $c, entity => \%machines_hash );
}


=head1 AUTHOR

Enrico Caleffi

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
