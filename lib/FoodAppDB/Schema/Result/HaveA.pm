package FoodAppDB::Schema::Result::HaveA;

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

FoodAppDB::Schema::Result::HaveA

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

Related object: L<FoodAppDB::Schema::Result::ProductOffer>

=cut

__PACKAGE__->belongs_to(
  "product_offer",
  "FoodAppDB::Schema::Result::ProductOffer",
  { id => "product_offer_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 product

Type: belongs_to

Related object: L<FoodAppDB::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "FoodAppDB::Schema::Result::Product",
  { id => "product_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-08 16:57:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4+oAyog3u/+vBvz2xmFjQA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
