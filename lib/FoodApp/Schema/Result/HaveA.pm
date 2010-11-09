package FoodApp::Schema::Result::HaveA;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

FoodApp::Schema::Result::HaveA

=cut

__PACKAGE__->table("has_a");

=head1 ACCESSORS

=head2 product_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 product_offer_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "product_offer_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("product_id", "product_offer_id");
__PACKAGE__->add_unique_constraint("product_offer_id_unique", ["product_offer_id"]);
__PACKAGE__->add_unique_constraint("product_id_unique", ["product_id"]);

=head1 RELATIONS

=head2 product_offer

Type: belongs_to

Related object: L<FoodApp::Schema::Result::ProductOffer>

=cut

__PACKAGE__->belongs_to(
  "product_offer",
  "FoodApp::Schema::Result::ProductOffer",
  { id => "product_offer_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 product

Type: belongs_to

Related object: L<FoodApp::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "FoodApp::Schema::Result::Product",
  { id => "product_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-10-29 11:26:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oEVS1wE3kamLKUdKkn+z5w


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
