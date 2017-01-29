# Hash extention to provide the ability to access properties using dot syntax.
# Example:
#
# user = { address: { street: { name: 'Buckingham Palace Road' } } }
# user.extend(H)
# puts user.address.street.name
#   => Buckingham Palace Road
module H
  def method_missing(sym, *)
    r = fetch(sym) do
      fetch(sym.to_s) do
        super
      end
    end
    Hash === r ? r.extend(H) : r
  end
end
