# Boot Container

This repository provides a containerized environment for building a bootable ISO image for my Desktop machine. It uses [`bootc`](https://bootc-dev.github.io/bootc//) as the core tool for this process.

In the past, I have used various method to achieve similar results (such as Packer controlling a full deployment pipeline to build custom images), but BootC offers a more streamlined and efficient approach.

## What is BootC / Bootable Container?

BootC is a tool that simplifies the process of creating bootable container images. It provides a set of commands and configurations to streamline the building, testing, and deployment of these images, making it easier for developers to work with containerized environments.

In a nutshell, with BootC, you can quickly create a full bootable artefact that can be used in various scenarios, such as virtual machine deployments, bare-metal installations, or cloud-based environments... everything with only a **Containerfile** (strictly equivalent to a Dockerfile).

![Bootable Container](https://docs.fedoraproject.org/en-US/bootc/_images/bootable-container.png)

By implementing a well-defined **Containerfile**, you can ensure that your bootable container image is built consistently and reliably, regardless of the underlying infrastructure.
