provider "google" {
    credentials = "${file("credentials.json")}"
    project = "sre-test-nh"
    region = "asia-southeast2"
}