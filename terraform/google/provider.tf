provider "google" {
    account_file = ""
    credentials = "${file("${var.gce_credentials}")}"
    project = "${var.gce_project}"
    region = "${var.gce_region}"
}
