package FoodAppDB::Schema::Result::Machine;

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

FoodAppDB::Schema::Result::Machine

=cut

__PACKAGE__->table("machine");

=head1 ACCESSORS

=head2 id

  data_type: (empty string)
  is_nullable: 0

=head2 name

  data_type: 'char'
  is_nullable: 0
  size: 32

=head2 address

  data_type: 'char'
  is_nullable: 1
  size: 64

=head2 city

  data_type: 'char'
  is_nullable: 1
  size: 32

=head2 province_state

  data_type: 'char'
  is_nullable: 1
  size: 32

=head2 postal_code

  data_type: 'char'
  is_nullable: 1
  size: 10

=head2 ip_address

  data_type: 'char'
  is_nullable: 1
  size: 16

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "", is_nullable => 0 },
  "name",
  { data_type => "char", is_nullable => 0, size => 32 },
  "address",
  { data_type => "char", is_nullable => 1, size => 64 },
  "city",
  { data_type => "char", is_nullable => 1, size => 32 },
  "province_state",
  { data_type => "char", is_nullable => 1, size => 32 },
  "postal_code",
  { data_type => "char", is_nullable => 1, size => 10 },
  "ip_address",
  { data_type => "char", is_nullable => 1, size => 16 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 machine_products

Type: has_many

Related object: L<FoodAppDB::Schema::Result::MachineProduct>

=cut

__PACKAGE__->has_many(
  "machine_products",
  "FoodAppDB::Schema::Result::MachineProduct",
  { "foreign.machine_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-08 16:57:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mtBO1yuIloTCdfWaMnhcAA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
