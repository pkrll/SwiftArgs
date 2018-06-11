//
// SwiftArgs.swift
// Created by Ardalan Samimi on 2018-06-11
//
import Foundation

internal struct StderrOutputStream: TextOutputStream {

  static var stream = StderrOutputStream()

  internal mutating func write(_ string: String) {
    fputs(string, stderr)
  }
}

internal struct StdoutOutputStream: TextOutputStream {

  static var stream = StdoutOutputStream()

  internal mutating func write(_ string: String) {
    fputs(string, stdout)
  }
}
