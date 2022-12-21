local present, indentomatic = pcall(require, "indent-o-matic")

if not present then
	return
end

indentomatic.setup {}
