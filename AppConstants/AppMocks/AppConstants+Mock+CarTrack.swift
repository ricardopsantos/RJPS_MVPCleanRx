//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RxSwift
import RxCocoa
//import RJPSLib

extension AppConstants.Mocks {

    public struct CarTrack {
        public static var get_200: String {
            return """
            [
            {
                "id": 1,
                "name": "Leanne Graham",
                "username": "Bret",
                "email": "Sincere@april.biz",
                "address": {
                  "street": "Kulas Light",
                  "suite": "Apt. 556",
                  "city": "Lisbon (Portugal)",
                  "zipcode": "92998-3874",
                  "geo": {
                    "lat": "38.736946",
                    "lng": "-9.142685"
                  }
                },
                "phone": "1-770-736-8031 x56442",
                "website": "hildegard.org",
                "company": {
                  "name": "Romaguera-Crona",
                  "catchPhrase": "Multi-layered client-server neural-net",
                  "bs": "harness real-time e-markets"
                }
              },
              {
                "id": 2,
                "name": "Ervin Howell",
                "username": "Antonette",
                "email": "Shanna@melissa.tv",
                "address": {
                  "street": "Victor Plains",
                  "suite": "Suite 879",
                  "city": "Braga (Portugal)",
                  "zipcode": "90566-7771",
                  "geo": {
                    "lat": "41.545448",
                    "lng": "-8.426507"
                  }
                },
                "phone": "010-692-6593 x09125",
                "website": "anastasia.net",
                "company": {
                  "name": "Deckow-Crist",
                  "catchPhrase": "Proactive didactic contingency",
                  "bs": "synergize scalable supply-chains"
                }
              },
              {
                "id": 3,
                "name": "Clementine Bauch",
                "username": "Samantha",
                "email": "Nathan@yesenia.net",
                "address": {
                  "street": "Douglas Extension",
                  "suite": "Suite 847",
                  "city": "Almada (Portugal)",
                  "zipcode": "59590-4157",
                  "geo": {
                    "lat": "38.676525",
                    "lng": "-9.165105"
                  }
                },
                "phone": "1-463-123-4447",
                "website": "ramiro.info",
                "company": {
                  "name": "Romaguera-Jacobson",
                  "catchPhrase": "Face to face bifurcated interface",
                  "bs": "e-enable strategic applications"
                }
              },
              {
                "id": 4,
                "name": "Patricia Lebsack",
                "username": "Karianne",
                "email": "Julianne.OConner@kory.org",
                "address": {
                  "street": "Hoeger Mall",
                  "suite": "Apt. 692",
                  "city": "Odivelas, Portugal",
                  "zipcode": "53919-4257",
                  "geo": {
                    "lat": "38.795368",
                    "lng": "-9.185180"
                  }
                },
                "phone": "493-170-9623 x156",
                "website": "kale.biz",
                "company": {
                  "name": "Robel-Corkery",
                  "catchPhrase": "Multi-tiered zero tolerance productivity",
                  "bs": "transition cutting-edge web services"
                }
              },
              {
                "id": 5,
                "name": "Chelsey Dietrich",
                "username": "Kamren",
                "email": "Lucio_Hettinger@annie.ca",
                "address": {
                  "street": "Skiles Walks",
                  "suite": "Suite 351",
                  "city": "Loulé, Portugal",
                  "zipcode": "33263",
                  "geo": {
                    "lat": "37.137920",
                    "lng": "-8.020216"
                  }
                },
                "phone": "(254)954-1289",
                "website": "demarco.info",
                "company": {
                  "name": "Keebler LLC",
                  "catchPhrase": "User-centric fault-tolerant solution",
                  "bs": "revolutionize end-to-end systems"
                }
              },
              {
                "id": 6,
                "name": "Mrs. Dennis Schulist",
                "username": "Leopoldo_Corkery",
                "email": "Karley_Dach@jasper.info",
                "address": {
                  "street": "Norberto Crossing",
                  "suite": "Apt. 950",
                  "city": "Moita, Portugal",
                  "zipcode": "23505-1337",
                  "geo": {
                    "lat": "38.652733",
                    "lng": "-8.990205"
                  }
                },
                "phone": "1-477-935-8478 x6430",
                "website": "ola.org",
                "company": {
                  "name": "Considine-Lockman",
                  "catchPhrase": "Synchronised bottom-line interface",
                  "bs": "e-enable innovative applications"
                }
              },
              {
                "id": 7,
                "name": "Kurtis Weissnat",
                "username": "Elwyn.Skiles",
                "email": "Telly.Hoeger@billy.biz",
                "address": {
                  "street": "Rex Trail",
                  "suite": "Suite 280",
                  "city": "Portimão, Portugal",
                  "zipcode": "58804-1099",
                  "geo": {
                    "lat": "37.138287",
                    "lng": "-8.537579"
                  }
                },
                "phone": "210.067.6132",
                "website": "elvis.io",
                "company": {
                  "name": "Johns Group",
                  "catchPhrase": "Configurable multimedia task-force",
                  "bs": "generate enterprise e-tailers"
                }
              },
              {
                "id": 8,
                "name": "Nicholas Runolfsdottir V",
                "username": "Maxime_Nienow",
                "email": "Sherwood@rosamond.me",
                "address": {
                  "street": "Esposende, Braga, Portugal",
                  "suite": "Suite 729",
                  "city": "Aliyaview",
                  "zipcode": "45169",
                  "geo": {
                    "lat": "41.530918",
                    "lng": "-8.780565"
                  }
                },
                "phone": "586.493.6943 x140",
                "website": "jacynthe.com",
                "company": {
                  "name": "Abernathy Group",
                  "catchPhrase": "Implemented secondary concept",
                  "bs": "e-enable extensible e-tailers"
                }
              },
              {
                "id": 9,
                "name": "Glenna Reichert",
                "username": "Delphine",
                "email": "Chaim_McDermott@dana.io",
                "address": {
                  "street": "Dayna Park",
                  "suite": "Suite 449",
                  "city": "Estoril, Portugal",
                  "zipcode": "76495-3109",
                  "geo": {
                    "lat": "38.710159",
                    "lng": "-9.401894"
                  }
                },
                "phone": "(775)976-6794 x41206",
                "website": "conrad.com",
                "company": {
                  "name": "Yost and Sons",
                  "catchPhrase": "Switchable contextually-based project",
                  "bs": "aggregate real-time technologies"
                }
              },
              {
                "id": 10,
                "name": "Clementina DuBuque",
                "username": "Moriah.Stanton",
                "email": "Rey.Padberg@karina.biz",
                "address": {
                  "street": "Kattie Turnpike",
                  "suite": "Suite 198",
                  "city": "Faro, Portugal",
                  "zipcode": "31428-2261",
                  "geo": {
                    "lat": "37.019356",
                    "lng": "-7.930440"
                  }
                },
                "phone": "024-648-3804",
                "website": "ambrose.net",
                "company": {
                  "name": "Hoeger LLC",
                  "catchPhrase": "Centralized empowering task-force",
                  "bs": "target end-to-end models"
                }
              }
            ]

            """
        }
    }
}
