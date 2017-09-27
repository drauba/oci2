data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_virtual_network" "main" {
  cidr_block     = "${var.CidrVCN}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "main"
}

resource "oci_core_dhcp_options" "dhcp-options1" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.main.id}"
  display_name   = "dhcp-options1"

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
}

resource "oci_core_subnet" "Subnet0" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "${var.CidrSubnet}"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.main.id}"
  security_list_ids   = ["${oci_core_security_list.SecurityList0.id}"]
  route_table_id      = "${oci_core_route_table.RouteTable0.id}"
  dhcp_options_id     = "${oci_core_dhcp_options.dhcp-options1.id}"
}

resource "oci_core_subnet" "Subnet1Database" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "${var.CidrSubnet1Database}"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.main.id}"
  security_list_ids   = ["${oci_core_security_list.SecurityList1Database.id}"]
  route_table_id      = "${oci_core_route_table.RouteTable0.id}"
  dhcp_options_id     = "${oci_core_dhcp_options.dhcp-options1.id}"
}

resource "oci_core_subnet" "Subnet2Shared" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "${var.CidrSubnet2Shared}"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.main.id}"
  security_list_ids   = ["${oci_core_security_list.SecurityList0.id}"]
  route_table_id      = "${oci_core_route_table.RouteTable0.id}"
  dhcp_options_id     = "${oci_core_dhcp_options.dhcp-options1.id}"
}

resource "oci_core_subnet" "Subnet3Public" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  cidr_block          = "${var.CidrSubnet3Public}"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.main.id}"
  security_list_ids   = ["${oci_core_security_list.SecurityList0.id}"]
  route_table_id      = "${oci_core_route_table.RouteTable0.id}"
  dhcp_options_id     = "${oci_core_dhcp_options.dhcp-options1.id}"
}

resource "oci_core_security_list" "SecurityList0" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.main.id}"
  display_name   = "security_list1"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "${var.CidrSubnet}"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "${var.CidrSubnet2Shared}"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "${var.CidrSubnet1Database}"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "${var.CidrDev}"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "${var.CidrVCNSharedServices}"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "6"
    source    = "${var.CidrTrendMicroDeepScan}"
    stateless = false

    tcp_options {
      "min" = 4118
      "max" = 4118
    }
  }

  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 22
      "max" = 22
    }
  }

  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 80
      "max" = 80
    }
  }
}

resource "oci_core_security_list" "SecurityList1Database" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.main.id}"
  display_name   = "security_list1"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "${var.CidrSubnet1Database}"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "${var.CidrSubnet}"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "${var.CidrDev}"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "${var.CidrVCNSharedServices}"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "6"
    source    = "${var.CidrTrendMicroDeepScan}"
    stateless = false

    tcp_options {
      "min" = 4118
      "max" = 4118
    }
  }
}

resource "oci_core_internet_gateway" "IGW0" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "InternetGateway0"
  vcn_id         = "${oci_core_virtual_network.main.id}"
}

resource "oci_core_route_table" "RouteTable0" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.main.id}"
  display_name   = "RouteTableForComplete"

  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.IGW0.id}"
  }
}
