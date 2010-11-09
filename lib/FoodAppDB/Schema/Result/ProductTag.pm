package FoodAppDB::Schema::Result::ProductTag;

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

FoodAppDB::Schema::Result::ProductTag

=cut

__PACKAGE__->table("product_tag");

=head1 ACCESSORS

=head2 tag_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 product_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "tag_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "product_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("tag_id", "product_id");

=head1 RELATIONS

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

=head2 tag

Type: belongs_to

Related object: L<FoodAppDB::Schema::Result::Tag>

=cut

__PACKAGE__->belongs_to(
  "tag",
  "FoodAppDB::Schema::Result::Tag",
  { id => "tag_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-08 16:57:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QFzzgr4TyZrGG/g7+X+WLg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
