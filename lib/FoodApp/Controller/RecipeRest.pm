package FoodApp::Controller::RecipeRest;
use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN {extends 'Catalyst::Controller::REST'; }

=head1 NAME

FoodApp::Controller::RecipeRest - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched FoodApp::Controller::RecipeRest in RecipeRest.');
}

=head2 rest_recipe_list

Routine che permette di ottenere una lista di ricette serializzata.

=cut

sub rest_recipe_list :Path('/rest/recipe') :Args(0) :ActionClass('REST') { }


=head2 rest_recipe_list_GET

=cut

sub rest_recipe_list_GET {
	my ($self, $c) = @_;
	
	##if ( $c->user_exists() ) {
	
	$c->req->content_type('application/json');
	
	my @recipes; ## Array di ricette
	my $recipe_rs = $c->model('FoodAppDB::Recipe')->search; ## ResultSet delle ricette
	my @products; ## Array di prodotti associati alle ricette
	my %recipe_hash; ## Hash finale da visualizzare in formato JSON
	while (my $recipe_row = $recipe_rs->next) {
	
		@products = ();	## Inizializzo l'array di prodotti
		
		foreach my $prod ($recipe_row->uses) {
			push @products, $prod->product->name;	## Inserisco nell'array ogni nome di prodotto associato alla ricetta
		}
		
		## Inserisco la descrizione della ricetta in un hash temporaneo
		my %recipe_item = ( description => $recipe_row->description, );
		
		## Inserisco l'array di prodotti nell'hash temporaneo con chiave 'products'
		push @{ $recipe_item {products} }, @products;
		
		## Inserisco l'hash temporaneo nell'array di ricette
		push @recipes, \%recipe_item;
	}
	
	## Associo l'array che contiene le ricette alla chiave 'recipes' nell'hash delle ricette
	$recipe_hash{'recipes'} = \@recipes;
	
	$self->status_ok( $c, entity => \%recipe_hash );
	
	#}
	
	#else {
	#	return $c->res->redirect( $c->uri_for(
	#		$c->controller('People')->action_for('login'),
	#		{status_msg => "Solo effettuando il login potrai visualizzare questo contenuto."} ) );
	#}
}

=head1 AUTHOR

enrico,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
