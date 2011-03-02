package FoodApp::Controller::Maps;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use Google::GeoCoder::Smart;
use Math::Trig;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

FoodApp::Controller::Maps - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched FoodApp::Controller::Maps in Maps.');
}

=head2 select_prods

Azione che permette agli utenti di specificare quali prodotti desiderano cercare
all'interno dei distributori.

=cut

sub select_prods :Local :Args(0) {
	my ( $self, $c ) = @_;
	
	if ($c->user_exists()) {
		
		$c->stash->{'template'} = 'maps/select_prods.tt';
	
		my $prods_rs = $c->model('FoodAppDB::MachineProduct')->search;
		
		## Array che contiene i prodotti contenuti nei distributori
		my @prods = (); 
		
		while (my $prod_item = $prods_rs->next) {
			## Inserisco nell'array i prodotti trovati solo una volta,
			# in modo tale che non ci siano duplicati
			my $trovato = 0;
			foreach my $p (@prods) {
				if ($p->name eq $prod_item->name) {
					$trovato = 1;
				}
			}
			if ($trovato == 0) {
				push @prods, $prod_item;
			}
		}
		
		## Inserisco la lista di prodotti trovata nello stash	
		$c->stash(prods => [ @prods ]);
	}
	else {
		return $c->res->redirect( $c->uri_for(
			$c->controller('People')->action_for('login'),
			{status_msg => "Devi effettuare il login per visualizzare questo contenuto."} ) );
	}

}

=head2 view

Azione per visualizzare una mappa che mostri il percorso per collegare l'utente al distributore più vicino.

=cut

sub view :Local :Args(0) {
	my ( $self, $c ) = @_;
	
	if (lc $c->req->method eq 'post') {
		my $params = $c->req->params;
		my $prod_sel = $params->{numSel};
		my @checks = $params->{check};
		my @checked = ();
		foreach (@checks) {
			push @checked, $_;
		}
			
		## Stampa di prova prodotti selezionati
		$c->log->debug("Prodotti selezionati");
		$c->log->debug(Dumper(@checked));
			
		## Dai prodotti selezionati, ricavo il/i loro id
		
		# Per prima cosa dal nome ottengo un oggetto prodotto
		my %hash_id_prod = ();
		my @products = ();
		foreach my $p (@checked) {
			my $prod_rs = $c->model('FoodAppDB')->resultset('MachineProduct')->search( { name => $p } );
			## Salvo in un hash la corrispondenza fra prodotto e id associati
			while (my $res = $prod_rs->next) {
				push @{ $hash_id_prod {$res->name} }, $res->id;
				push @products, $res;
			}
		}
			
		## Stampa di prova dell'hash trovato
		$c->log->debug(Dumper(\\%hash_id_prod));
		if (! @products) {
			$c->res->redirect( $c->uri_for( $c->controller('Maps')->action_for('select_prods'),
				{status_msg => "Devi selezionare almeno un prodotto per proseguire."} ) );
			$c->detach();
		}
			
		## Elimino i duplicati da @products
		my @unique_products = ();
		my $prod = shift (@products);
		push @unique_products, $prod;
		foreach my $p (@products) {
			my $trovato = 0;
			foreach my $up (@unique_products) {
				if ($up->name eq $p->name) {
					$trovato = 1;
				}
			}
			if ($trovato == 0) {
				push @unique_products, $p;
			}
		}
			
		foreach my $up (@unique_products) {
			$c->log->debug("Prodotto unico: ".$up->name);
		}
			
		#Ricavo il numero di prodotti selezionati
		my $num_prods = keys %hash_id_prod;
		$c->log->debug("Numero selezionati: ".$num_prods);
			
		#Prelevo il primo prodotto
		my $first_prod = shift (@unique_products);
		$c->log->debug("Primo prodotto: ".$first_prod->name);
		#Ricavo il/gli id associati
		my @first_prod_ids = $hash_id_prod{$first_prod->name};
		$c->log->debug(Dumper(@first_prod_ids));
			
		#Trovo i distributori che lo/li contengono
		my @mac_id = ();
		foreach my $id (@first_prod_ids) {
			my $mac_res = $c->model('FoodAppDB')->resultset('ProductContained')->search( {product_id => $id} );
			while (my $res = $mac_res->next) {
				push @mac_id, $res->machine_id;
			}
		}
		$c->log->debug(Dumper(@mac_id));
			
		# Cerco gli altri prodotti che contengono i distributori trovati
		my %hash_res = ();
		foreach my $id (@mac_id) {
		my $prods = $c->model('FoodAppDB::ProductContained')->search( { machine_id => $id} );
			while (my $p = $prods->next) {
				push @{ $hash_res {$id} }, $p->product_id;
			}
		}
		$c->log->debug(Dumper(\\%hash_res));
			
		# Ora ho un hash che ha come chiave lo id dei distributori trovati a partire dal primo
		# prodotto e come valori gli id dei prodotti che tale distributore contiene.
		# Adesso controllo che fra questi id ci siano quelli degli altri prodotti selezionati
		# dall'utente.
			
		# Per prima cosa controllo che l'utente abbia selezionato più di un prodotto, perché 
		# altrimenti ho già il risultato.
		my @res = (); # array che conterrà gli id delle macchine trovate come risultato
		if ($num_prods > 1) {
			## Considero una alla volta le chiavi dell'hash %hash_res
			foreach my $key (keys %hash_res) {
				#$c->log->debug("chiave ".$key);
				# Ricavo la lista di prodotti associati al distributore con quella chiave
				my @p_ids = ();
				my $prods = $c->model('FoodAppDB::ProductContained')->search( { machine_id => $key} );
				while (my $p = $prods->next) {
					push @p_ids, $p->product_id;
				}
				$c->log->debug(Dumper(@p_ids));
				
				my $ntrovati = 1;
				# Prendo ciascuno degli altri prodotti selezionati
				foreach my $p (@unique_products) {
					#$c->log->debug("Prodotto considerato: ".$p->name );
					
					##Ricavo gli id del prodotto considerato
					my @prod_ids = ();
					my $prods_rs = $c->model('FoodAppDB::MachineProduct')->search( { name => $p->name} );
					while (my $pr = $prods_rs->next) {
						push @prod_ids, $pr->id;
					}
					
					foreach my $id (@prod_ids) {
						#$c->log->debug("id = ".$id);
						foreach my $mid (@p_ids) {
							#$c->log->debug("mid = ".$mid);
							if ($id == $mid) {
								$ntrovati++;
								#$c->log->debug("ntrovati => ".$ntrovati);
							}
						}
					}
					#my @p_id = $hash_id_prod{$p->name};
					#$c->log->debug(Dumper($p_id));
					##Cerco tali id nel distributore corrente
					#foreach my $prod_id ($p_id->next) {
					#	$c->log->debug("prod_id = ".$prod_id);
					#	foreach my $mach_id (@ids) {
					#		$c->log->debug("mach_id = ".$mach_id);
					#		if ($prod_id == $mach_id) {
					#			$ntrovati ++;
					#			$c->log->debug("ntrovati => ".$ntrovati);
					#		}
					#	}
					#}
					
					if ($ntrovati == $num_prods) {
						push @res, $key;
					}
					
				}
			}
		}
		else { # le macchine trovate sono tutte le chiavi di %hash_res
			@res = keys %hash_res;
		}
			
		if (@res) {
			# Stampa di prova del risultato
			foreach my $r (@res) {
				$c->log->debug("Distributore trovato: id => ".$r);
			}
		}
		else {
			$c->res->redirect( $c->uri_for( $c->controller('Maps')->action_for('select_prods'),
				{status_msg => "Non è stato trovato alcun distributore con i prodotti selezionati."} ) );
				$c->detach();
		}
			
		if ($c->user_exists()) {

			$c->stash->{'template'} = 'maps/view.tt';

			## Ricavo l'utente dalla sessione
			my $user = $c->user;
			## L'indirizzo di partenza è l'indirizzo dell'utente inserito in fase di registrazione
			my $source = $c->user->address.", ". $c->user->city;
			$c->log->debug($source);
			
			my $geo = Google::GeoCoder::Smart->new();
			my ($resultnum, $error, @results, $returncontent) = $geo->geocode(
								"address" => $source);
			my $lat = $results[0]{geometry}{location}{lat};
 			my $lng = $results[0]{geometry}{location}{lng};
 			$c->log->debug("Coordinate: ".$lat.", ".$lng);
		
			## Trovo il distributore più vicino alla posizione corrente dell'utente
			my $dist = 0;
			my $min_lat;
			my $min_lng;
			my $k = 0;
			foreach my $i (@res) {
				#Costante pigreco
				my $pi = atan2(1,1) * 4;
				
				#Coordinate in radianti del punto di partenza
				my $lat_alfa = $pi * $lat / 180;
				my $lng_alfa = $pi * $lng / 180;
			
				my $mach = $c->model('FoodAppDB::Machine')->find({ id => $i});
				my $mlat = $mach->latitude;
				my $mlng = $mach->longitude;
				#Coordinate in radianti del punto di arrivo
				my $lat_beta = $pi * $mlat / 180;
				my $lng_beta = $pi * $mlng / 180;
				
				my $fi = abs($lng_alfa - $lng_beta);
				my $p = acos( sin($lat_beta) * sin($lat_alfa) +
						cos($lat_beta) * cos($lat_alfa) * cos($fi));
				my $RT = 6371; #Raggio terrestre in km
				my $d = $p * $RT;
				
				$c->log->debug("distanza: ".$d);
				
				if ($k == 0 ) {
					$dist = $d;
					$min_lat = $mlat;
					$min_lng = $mlng;
					$k++;
				}
				else {
					if ($d < $dist) {
						$dist = $d;
						$min_lat = $mlat;
						$min_lng = $mlng;
					}
				}
				
			}
			$c->log->debug("minima distanza: ".$dist." , lat: ".$min_lat.", lng: ".$min_lng);
			
			my $coord = $min_lat.", ". $min_lng;
			## Ricavo le coordinate del distributore trovato
			#my $id = shift @res;
			#my $mac = $c->model('FoodAppDB::Machine')->find({ id => $id});
			#my $coord = $mac->latitude .", ". $mac->longitude;
			#$c->log->debug("Coordinate distributore: ".$coord);
		
			my $point1 = "44.88734, 11.05997";
			my $point2 = $source;
			my $point3 = $coord;
			
			my $start = $lat.", ".$lng;
			my $end = $coord;

			$c->stash( 	point1 => $point1,
						point2 => $point2,
						point3 => $point3);
			$c->stash(	start	=> $start,
						end	=> $end);
		}
		else {
			return $c->res->redirect( $c->uri_for(
				$c->controller('People')->action_for('login'),
				{status_msg => "Devi effettuare il login per visualizzare questo contenuto."} ) );
		}
			
	}
	
	
}


=head1 AUTHOR

Enrico Caleffi

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
