#import "@preview/linguify:0.4.0": *

#let parametirizeLinguify = () => {
  let lang_data = toml("lang.toml")
  (key) => linguify(key, from: lang_data)
}

#let localize = parametirizeLinguify()

#let header(info, client-info, object) = {
  grid(
    columns: (1fr, 1fr),
    text({
      strong(info.name)
      linebreak()
      info.address
      info.mail
      linebreak()
      info.tel
      linebreak()
      text()[*N° Siret:* #info.siret]
      linebreak()
      info.immatriculation
    }),
    text({
      set align(right)
      block(
        fill: luma(230),
        inset: 30%,
        height: 3em,
        {
          v(0.5em)
          set align(center)
          text(size: 25pt)[
            #upper(object)
            // #upper(localize("facture"))
          ]
        }
      )
      strong(client-info.name)
      linebreak()
      client-info.address
    })
  )
}

#let footer(info, bank-account, conditions, vat_non_applicable: false) = {

  if vat_non_applicable {
    [
      #emph[#localize("293b_vat") \ ]
    ]
  }

  [
    \
    #strong[#localize("coordonees_bancaires")] \
    #strong[#localize("titulaire_du_compte"):] #bank-account.account-owner \
    #strong[#localize("banque"):] #bank-account.bank-address \
    #strong[#localize("iban"):] #bank-account.iban \
    #strong[#localize("code_bic"):] #bank-account.bic

    #emph[#conditions]
  ]
}

#let details_from_csv = (data, tjm) => {
  // Parse the data
  // let data = csv(data, delimiter: ";")
  let data = data.slice(1)

  // Compute the total time in minutes
  let total-minutes = data.map(
    ((date, time, title)) => time.match(regex("((\d+)h[ ])?(\d+)m"))
  ).filter((cpt) => cpt != none).map(capture => if capture.captures.at(1) != none {
      int(capture.captures.at(1)) * 60 + int(capture.captures.at(2))
    }
    else {
      int(capture.captures.at(2))
    }
  ).fold(0, (acc, minutes) => acc + minutes)


  let hours = int(total-minutes / 60)
  let minutes = calc.rem(total-minutes, 60)

  // Compute price
  let thm = 700 / 7
  let float-hours = total-minutes / 60
  let total = float-hours * thm

  [
    // body
    #localize("details_des_operations"):

    #table(
      columns: (auto, auto, 1fr),
      [#localize("date")], [#localize("temps")], [#localize("detail")],
      ..data.flatten(),
    )
    #localize("pour_un_total") #hours\h #localize("et") #minutes\m.

    #table(
      columns: (auto, 1fr, auto, auto),
      align: horizon,
      [ #localize("quantite") ], [#localize("designation")], [#localize("prix_unitaire_ht")], [#localize("prix_total_ht")],
      [ #hours\h #minutes\m ], [ #localize("taux_journalier_moyen") ], [ #tjm € ], [ #calc.round(total, digits: 2) €]
    )
  ]
}

#let invoice(
  title,
  user-info,
  bank-account,
  client-info,
  month,
  conditions,
  body,
  lang: "fr",
  vat_non_applicable: false,
  object: none) = {
  let today = datetime.today()
  set page(
    paper: "a4",
    margin: (x: 4%, top: 2%, bottom: 2%),
  )
  set text(size: 12pt)

  if object == none {
    object = upper(localize("facture"))
  }
  header(user-info, client-info, object)

  line(length: 100%)

  text([
    #localize("reference"): #client-info.number\_#today.year()\_0#{month} #h(1fr)
    #localize("date"): #today.day() / #today.month() / #today.year()    \
    #localize("n_client"): #client-info.number

    #underline[#localize("intitule"):] #title \
  ])

  block[
      #body
  ]

  block(breakable: false)[
    #footer(user-info, bank-account, conditions, vat_non_applicable: vat_non_applicable)
  ]
}

#let signs(client, me) = {
grid(
  columns: (1fr, 1fr),
  text([
    *Signature du client* : #client \
    *Date* : \
    *Signature* : \
  ]),
  text([
    *Signature de l'émetteur du devis :*
    #me
    *Date*: \
    *Signature* :
  ]))
}

#let quotation(
  title,
  user-info,
  bank-account,
  client-info,
  month,
  conditions,
  body,
  lang: "fr",
  vat_non_applicable: false) = {
  let today = datetime.today()
  set page(
    paper: "a4",
    margin: (x: 4%, top: 2%, bottom: 2%),
  )
  set text(size: 12pt)

  let object = upper(localize("devis"))

  header(user-info, client-info, object)

  line(length: 100%)

  text([
    #localize("reference"): #client-info.number\_#today.year()\_0#{month} #h(1fr)
    #localize("date"): #today.day() / #today.month() / #today.year()    \
    #localize("n_client"): #client-info.number
    == #underline[*#localize("intitule"):*] #title \
    #v(0.6em)
  ])

  block[
      #body
  ]
}
