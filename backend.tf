terraform {
  cloud {
    organization = "kattakath-technologies-inc"

    workspaces {
      name = "corp-website"
    }
  }
}
