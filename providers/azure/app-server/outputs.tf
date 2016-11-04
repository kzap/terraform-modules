output "vm_ids" {
	value = ["${azurerm_virtual_machine.appserver_vm.*.id}"]
}

output "vm_pips" {
	value = ["${azurerm_public_ip.appserver_pip.*.ip_address}"]
}