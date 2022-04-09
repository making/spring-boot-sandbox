package com.example.misc;

import java.util.Objects;

public class Foo {

	private final String name;

	public Foo(String name) {
		this.name = name;
	}

	public Foo() {
		this("");
	}

	@Override
	public int hashCode() {
		return Objects.hash(name);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		var other = getClass().cast(obj);
		return Objects.equals(name, other.name);
	}

	@Override
	public String toString() {
		return "Foo(" + name + ")";
	}
}
