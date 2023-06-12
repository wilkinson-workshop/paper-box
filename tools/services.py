#!/bin/python3.11

"""
Manage and maintain container services for the
Minecraft host.
"""

import argparse, os, pathlib, subprocess, typing


class ServicesNamespace(argparse.Namespace):
    bind: pathlib.Path | str
    callback: typing.Callable
    name: str
    ports: str
    tag: str
    target: str


def build_service(args: ServicesNamespace, target: str = None):
    if not target:
        target = args.target
    return subprocess.call([
        "docker",
        "build",
        ".",
        f"--tag={args.tag}",
        f"--target={target}"])


def start_service(args: ServicesNamespace):
    bind = pathlib.Path(args.bind).absolute()

    create = [
        "docker",
        "create",
        "--rm",
        f"--name={args.name}",
        f"--mount=type=bind,source={bind},target=/opt/app"]
    if args.ports:
        create.extend([f"-p={p}" for p in args.ports.split(",")])
    create.append(args.tag)

    rt = subprocess.call(create)

    if rt > 0:
        return rt

    rt = subprocess.call([
        "docker",
        "start",
        args.name])
    return rt


def stop_service(args: ServicesNamespace):
    return subprocess.call(["docker", "stop", args.name])


def add_service_common_args(
    parser: argparse.ArgumentParser, name: str, tag: str):
    """
    Add common default options for services.
    """

    parser.add_argument("-b", "--bind",
        help="local bind location.",
        default=pathlib.Path.cwd() / "test")
    parser.add_argument("-n", "--name",
        help="container name.",
        default=name)
    parser.add_argument("-p", "--ports", help="port bindings.", default=None)
    parser.add_argument("-t", "--tag",
        help="image name.",
        default=tag)


def add_action_common_args(parser: argparse.ArgumentParser, target: str):
    """Add common default options for actions."""

    subparsers = parser.add_subparsers(
        title="Actions.",
        required=True)

    build = subparsers.add_parser("build")
    build.set_defaults(callback=build_service, target=target)

    start = subparsers.add_parser("start")
    start.set_defaults(callback=start_service)

    stop = subparsers.add_parser("stop")
    stop.set_defaults(callback=stop_service)


def main():
    # Initialize the Root parser.
    root = argparse.ArgumentParser(
        os.path.basename(__file__),
        description="Minecraft containers.")

    # Setup services subparser section.
    subparsers = root.add_subparsers(
        title="services",
        required=True)

    # Proxy subparser and it's actions.
    parser_proxy = subparsers.add_parser(
        "proxy",
        help="manage proxy server container.")
    add_service_common_args(parser_proxy, "sinatra-new-york", "paper-mc-proxy")
    add_action_common_args(parser_proxy, "proxy")

    # Server subparser and it's actions.
    parser_server = subparsers.add_parser(
        "server",
        help="manage server instance container.")
    add_service_common_args(parser_server, "sinatra-blue-moon", "paper-mc-server")
    add_action_common_args(parser_server, "server")

    # Do final callback base on arguments given.
    args = root.parse_args(namespace=ServicesNamespace)
    args.callback(args)

    return 0


if __name__ == "__main__":
    exit(main())
