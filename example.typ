#import "invoice.typ" : invoice

#let my-information = (
  name: [John Doe],
  // Only in france ?
  siret: [00000000000000],
  immatriculation: [],
  mail: [#link("mailto:john.doe@domain.com")],
  address: [
    1 road Somewhere \
    Anywhere
  ],
  tel: [+00000000000],
  conditions: [

  ]
)

// This is the client info, needs to be dynamically loaded
#let client-information = (
    name: [ Client Name ],
    address: [ 122 road \ Paris],
    number: [0000],
  )

// Bank account information
#let bank-account = (
    account-owner : [John Doe],
    bank-address: [ 1 road, Elsewhere ],
    iban: [AB00 0000 0000 0000 0000 0000 000],
    bic: [ AAAAAAAA ]
  )

// Title
#let title = "Title"

#let conditions = [ Payement due ASAP]

#let month = sys.inputs.at("month", default: datetime.today().month())

// Set the lang for localize package
#set text(lang: "en")
// Show links in blue
#show link: set text(blue.darken(30%))

// Load the invoice template
#show: body => invoice(title, my-information, bank-account, client-information, month, [  ], body)

// This part is the body of the invoice, write down what you did
Details of the operations

#v(31em)

// Simple table with the price
#table(
   columns: (1fr, auto),
   [ *Total* ], [ 1 000 000\$ ]
)
