//
// Array+Argument.swift
// Created by Ardalan Samimi on 2018-06-10
//
extension Array where Element:Argument {

	subscript(name: String) -> Argument? {
		return self.element(withName: name)
	}

	func element(withName name: String) -> Argument? {
		return self.filter { $0.equals(name) }.first
	}

	func contains(_ element: String) -> Bool {
		return self.filter { $0.equals(element) }.count > 0
	}

}
