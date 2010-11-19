package FoodApp::Schema::Result::HandelOrder;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "EncodedColumn");

=head1 NAME

FoodApp::Schema::Result::HandelOrder

=cut

__PACKAGE__->table("handel_order");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 order_number

  data_type: 'varchar'
  is_nullable: 0
  size: 36

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "order_number",
  { data_type => "varchar", is_nullable => 0, size => 36 },
);
__PACKAGE__->set_primary_key("user_id", "order_number");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<FoodApp::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "FoodApp::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-19 10:43:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AzZ6+1fdvyIyQbw+sVCh/Q


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
